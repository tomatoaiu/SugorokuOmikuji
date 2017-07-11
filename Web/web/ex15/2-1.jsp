<!--
    ログイン
-->
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:useBean id="user" scope="session" class="ex15.UserDB" />
<%@page import="java.util.*" %>
<%

    String id = "";
    String pass = "";

    /* パラメータの取得 */
    if (request.getParameter("id") != null) {
        id = request.getParameter("id");
    }

    if (request.getParameter("pass") != null) {
        pass = request.getParameter("pass");
    }

    /* データ一覧の取得メソッド */
    try {

        if (0 == user.loginNameMatch(id, pass)) {
%>
<jsp:forward page="3.jsp" />
<%
} else {
%>
<jsp:forward page="errorUserDB.jsp" />
<%
    }
%>
<%
} catch (Exception e) {
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>エラーの表示</title>
    </head>
    <body>
        <header>
            <h1>エラーの表示</h1>
        </header>
        <article>
            データベースに接続できませんでした。
        </article>
    </body>
</html>

<%
    }
%>
