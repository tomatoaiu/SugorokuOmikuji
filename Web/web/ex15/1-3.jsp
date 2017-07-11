<!-- 
    新規登録の情報を送信
-->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="ex15.UserDB" />
<%

    request.setCharacterEncoding("UTF-8");
    
    String newid = "";
    String newpass = "";

    /* パラメータの取得 */
    if (request.getParameter("newid") != null) {
        newid = request.getParameter("newid");
    }

    if (request.getParameter("newpass") != null) {
        newpass = request.getParameter("newpass");
    }

    /* データ一覧の取得メソッド */
    try {

        if (1 == user.newUserCheck(newid, newpass)) {
            user.newinsert(newid, newpass);
            user.dataload();
%>
<jsp:forward page="3.jsp" />
<%
} else {
%>
<jsp:forward page="errorsignup.jsp" />
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
