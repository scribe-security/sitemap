<%@ page language="java" contentType="text/xml;charset=UTF-8" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="`url" type="org.jahia.services.render.URLGenerator"--%>

<c:set var="entryNode" value="${currentNode.parent}"/>

<c:if test="${entryNode.properties['createSitemap'].boolean}">
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="https://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:xhtml="https://www.w3.org/1999/xhtml">

    <%-- current page node --%>
    <c:set var="urlNode" value="${entryNode}" scope="request"/>
    <jsp:include page="../../common/sitemap-entry.jsp"/>

    <%-- jnt:page under currentNode --%>
    <jcr:sql var="childUrlNodes"
             sql="SELECT * FROM [jnt:page] WHERE ISDESCENDANTNODE('${entryNode.path}')
             and ([createSitemap] IS NULL or [createSitemap] = false)"/>
    <c:forEach items="${childUrlNodes.nodes}" var="childUrlNode">
        <c:set var="urlNode" value="${childUrlNode}" scope="request"/>
        <jsp:include page="../../common/sitemap-entry.jsp"/>
    </c:forEach>

    <%-- jmix:mainResource under currentNode --%>
    <jcr:sql var="childUrlNodes"
             sql="SELECT * FROM [jmix:mainResource] WHERE ISDESCENDANTNODE('${entryNode.path}')
             and ([createSitemap] IS NULL or [createSitemap] = false)"/>
    <c:forEach items="${childUrlNodes.nodes}" var="childUrlNode">
        <c:set var="urlNode" value="${childUrlNode}" scope="request"/>
        <jsp:include page="../../common/sitemap-entry.jsp"/>
    </c:forEach>

</urlset>
</c:if>
