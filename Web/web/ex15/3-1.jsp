<!--
    ハイスコア、ロースコア更新
-->

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="ex15.UserDB" />
<jsp:useBean id="history" scope="session" class="ex15.HistoryDB" />

<% /* エンコード */

    request.setCharacterEncoding("UTF-8");

    /* 変数の宣言　*/
    String highPoint = "";
    String lowPoint = "";

    String history1 = "";
    String history2 = "";
    String history3 = "";
    String history4 = "";
    String history5 = "";
    
    String point = "";

//    String[] arrayhistory2 = new String[100];
//    String[] arrayhistory3 = new String[100];
//    String[] arrayhistory4 = new String[100];
//    String[] arrayhistory5 = new String[100];


    /* パラメータの取得 */
    if (request.getParameter("highPoint") != null) {
        highPoint = request.getParameter("highPoint");
    }
    if (request.getParameter("lowPoint") != null) {
        lowPoint = request.getParameter("lowPoint");
    }

    if (request.getParameter("history1") != null) {
        history1 = request.getParameter("history1");
    }
    if (request.getParameter("history2") != null) {
        history2 = request.getParameter("history2");
    }
    if (request.getParameter("history3") != null) {
        history3 = request.getParameter("history3");
    }
    if (request.getParameter("history4") != null) {
        history4 = request.getParameter("history4");
    }
    if (request.getParameter("history5") != null) {
        history5 = request.getParameter("history5");
    }
    
    if (request.getParameter("point") != null) {
        point = request.getParameter("point");
    }
    
    session.setAttribute("point", point);
    
    String[] arrayhistory2 = history2.split(",", 0);
    String[] arrayhistory3 = history3.split(",", 0);
    String[] arrayhistory4 = history4.split(",", 0);
    String[] arrayhistory5 = history5.split(",", 0);

    /* updateメソッドの実行 */
    int err = user.update(user.getName(user.getPlayer()), user.getPassword(user.getPlayer()), highPoint, lowPoint);

    int errHistory = 0;
    for (int i = 0; i < arrayhistory2.length; i++) {
        errHistory = history.insert(history1, arrayhistory2[i], arrayhistory3[i], arrayhistory4[i], arrayhistory5[i]);
    }
%>
<% if (err != 0 || errHistory != 0) { %>
<jsp:forward page="4.jsp" />
<% } else {%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>エラーの出力</title>
    </head>
    <body>
        <header>
            <h1>エラーの出力</h1>
        </header>
        <article>
            データベースに接続できませんでした。<br /><br />
        </article>
    </body>
</html>
<% }%>
