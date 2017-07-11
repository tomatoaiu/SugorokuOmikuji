<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Omikuji_Login</title>
        <link rel="stylesheet" type="text/css" href="css/1.css">
    </head>
    <body>
        <div id="container">
            <article>
                <h1>新規登録</h1>

                <form method="POST" action="1-3.jsp"  class="animsition">
                    
                    ユーザー名：<input type="text" name="newid" value="" size="30" placeholder="ユーザー名を入力してください"  required/><br />
                    パスワード：<input type="password" name="newpass" value="" size="30" placeholder="半角・英数" required/><br />
                    <div id="sendButtonPosition">
                        <input type="submit" value="登録" class="sendButton">
                    </div>
                    
                </form>
                
                <form method="POST" action="1.jsp"  class="animsition">
                    <div id="signupPosition">
                        <input type="submit" value="戻る" class="signupButton">
                    </div>
                    
                </form>

            </article>
        </div><!-- container -->
    </body>
</html>