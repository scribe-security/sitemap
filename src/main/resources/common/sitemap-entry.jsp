<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sitemap" uri="http://www.jahia.org/sitemap" %>

<c:if test="${!requestScope.urlNode.properties['noIndex'].boolean}">
<jcr:nodeProperty var="lastModified" node="${requestScope.urlNode}" name="jcr:lastModified"/>
<url>
    <c:url var="vanityUrl" value="${sitemap:getVanityUrl(requestScope.urlNode)}"/>
    <c:set var="finalUrl" value="${ (not empty vanityUrl) ? vanityUrl : requestScope.urlNode.url }"/>
    <loc>${url.server}<c:url value="${finalUrl}"/></loc>
    <lastmod><fmt:formatDate value="${lastModified.date.time}" pattern="yyyy-MM-dd"/></lastmod>

    <c:set var="locales" value="${requestScope.urlNode.getExistingLocales()}"/>
    <c:if test="${locales.size() > 1}"><%-- no need for alt if there's only one locale --%>
        <c:forEach var="locale" items="${locales}">
            <c:set var="lang" value="${locale.toString()}"/>

            <c:url var="vanityUrl" value="${sitemap:getLocaleVanityUrl(requestScope.urlNode, lang)}"/>
            <c:url var="localeUrl" value="${url.getBase(lang)}${requestScope.urlNode.path}.html"/>
            <c:set var="localeAltUrl" value="${ (not empty vanityUrl) ? vanityUrl : localeUrl }"/>

            <xhtml:link rel="alternate" hreflang="${lang}" href="${url.server}${localeAltUrl}"/>
        </c:forEach>
    </c:if>
</url>
</c:if>
