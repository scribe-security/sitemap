/*
 * ==========================================================================================
 * =                            JAHIA'S ENTERPRISE DISTRIBUTION                             =
 * ==========================================================================================
 *
 *                                  http://www.jahia.com
 *
 * JAHIA'S ENTERPRISE DISTRIBUTIONS LICENSING - IMPORTANT INFORMATION
 * ==========================================================================================
 *
 *     Copyright (C) 2002-2021 Jahia Solutions Group. All rights reserved.
 *
 *     This file is part of a Jahia's Enterprise Distribution.
 *
 *     Jahia's Enterprise Distributions must be used in accordance with the terms
 *     contained in the Jahia Solutions Group Terms &amp; Conditions as well as
 *     the Jahia Sustainable Enterprise License (JSEL).
 *
 *     For questions regarding licensing, support, production usage...
 *     please contact our team at sales@jahia.com or go to http://www.jahia.com/license.
 *
 * ==========================================================================================
 */
package org.jahia.modules.sitemap.utils;

import org.jahia.api.Constants;
import org.jahia.services.content.*;
import org.jahia.services.render.RenderContext;

import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.jcr.query.Query;
import javax.jcr.query.QueryResult;
import java.util.*;

/**
 * Utility helper class for Sitemap
 */
public final class QueryHelper {

    private QueryHelper() {}

    /** Check if node is a descendant of the list of parent excluded nodes */
    public static boolean excludeNode(JCRNodeWrapper node, NodeIterator excludeNodesIter) {
        String nodePath = node.getPath();
        while (excludeNodesIter.hasNext()) {
            JCRNodeWrapper p = (JCRNodeWrapper) excludeNodesIter.nextNode();
            if (nodePath.startsWith(p.getPath())) return true;
        }
        return false;
    }

    /**
     * @return sitemap entries that are publicly accessible
     */
    public static List<JCRNodeWrapper> getSitemapEntries(RenderContext ctx, String rootPath, String nodeType) throws RepositoryException {
        String query = "SELECT * FROM [%s] WHERE ISDESCENDANTNODE('%s') and ([createSitemap] IS NULL or [createSitemap]=false)";
        QueryResult queryResult = getQuery(ctx.getSite().getSession(), String.format(query, nodeType, rootPath));

        Set<String> inclPaths = getGuestNodes(rootPath, nodeType);
        List<JCRNodeWrapper> result = new LinkedList<>();
        for (NodeIterator iter = queryResult.getNodes(); iter.hasNext(); ) {
            JCRNodeWrapper n = (JCRNodeWrapper) iter.nextNode();
            if (inclPaths.contains(n.getPath())) result.add(n);
        }
        return result;
    }

    public static Set<String> getGuestNodes(String rootPath, String nodeType) throws RepositoryException {
        String query = "SELECT * FROM [%s] WHERE ISDESCENDANTNODE('%s')";
        JCRSessionWrapper liveGuestSession = JCRSessionFactory.getInstance().login("live");
        QueryResult queryResult = getQuery(liveGuestSession, String.format(query, nodeType, rootPath));
        Set<String> result = new HashSet<>();
        for (NodeIterator iter = queryResult.getNodes(); iter.hasNext(); ) {
            JCRNodeWrapper n = (JCRNodeWrapper) iter.nextNode();
            result.add(n.getPath());
        }
        return result;
    }

    public static QueryResult getQuery(JCRSessionWrapper session, String query) {
        try {
            return session.getWorkspace().getQueryManager()
                    .createQuery(query, Query.JCR_SQL2).execute();
        } catch (RepositoryException e) {
            return null;
        }
    }

}
