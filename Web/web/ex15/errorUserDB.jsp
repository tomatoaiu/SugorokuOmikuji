<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="ex15.UserDB" />
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
            <form action="/Web/ex15/1.jsp" method="post" class="animsition">
                <p>データベースにアクセスできませんでした。</p>
                <p>ユーザー名、パスワードを再度お確かめください。</p>
                <div id="sBtnPosition">
                    <input type="submit" value="戻る" class="sendButton">
                </div>
            </form>
        </article>
    </body>
</html>
