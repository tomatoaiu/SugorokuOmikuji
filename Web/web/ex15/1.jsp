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
                <h1>すごろくおみくじ</h1>

                <!-- (1)<FORM>タグにmultipart/form-dataを指定 -->
                <form method="POST"  action="2-1.jsp"  class="animsition">
                    
                    ユーザー名：<input type="text" name="id" value="" size="30" placeholder="ユーザー名を入力してください" required/><br />
                    パスワード：<input type="password" name="pass" value="" size="30" placeholder="半角・英数" required/><br />
                    <div id="sendButtonPosition">
                        <input type="submit" value="ログイン" class="sendButton">
                    </div>
                    
                </form>
                
                <form method="POST" action="1-2.jsp"  class="animsition">
                    <div id="signupPosition">
                        <input type="submit" value="新規登録" class="signupButton">
                    </div>
                    
                </form>

            </article>
        </div><!-- container -->
    </body>
</html>