<!--
    新規登録
-->

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<jsp:useBean id="user" scope="session" class="ex15.UserDB" />
<%@page import="java.util.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Omikuji</title>
        <link rel="stylesheet" type="text/css" href="css/3.css">

        <script src="js/jquery.js"></script>
        <script src="js/jquery.cookie.min.js"></script>

    </head>
    <body>
        <div id="container">
            <div id="startButton"><p>サイコロを振る</p></div>
            <div id="userName"><%=user.getName(user.getPlayer())%></div>
            <div id="high">ハイスコア:</div>
            <div id="highscore"><%=user.getHighscore(user.getPlayer())%>pt</div>
            <div id="low">ロースコア:</div>
            <div id="lowscore"><%=user.getLowscore(user.getPlayer())%>pt</div>
            <div id="saikoro"></div>
            <div id="point">00000pt</div>
            <div id="sum">合計:</div>
            <div id="process">+0pt</div>
            <div id="nowMass">現在のマス:</div>
            <div id="explain">
                <img src="images/point1.png" width="220px;" height="300px">
            </div><!-- explain -->
            <div id="massexplain">
                <img src="images/massexplain.png" width="220px;" height="180px">
            </div><!-- massexplain -->
            <header>
                <img src="images/title2.png" width="400px;" height="100px">
            </header>
            <nav></nav>
            <article>
                <%
                    for (int i = 1; i <= 50; i++) {
                        out.print("<div id=circle" + i + ">");
                        if (i % 10 == 0) {
                            out.print("<button type=button class=circleGreen></button><br />");
                        } else if (i % 2 == 0) {
                            out.print("<button type=button class=circleRed></button><br />");
                        } else {
                            out.print("<button type=button class=circleBlue></button><br />");
                        }
                        out.print("</div>");
                    }
                %>
            </article>
            <article>
                <p id="result">ゴール</p>
                <form method="POST" action="3-1.jsp" class="animsition" name="keisan">
                    <div id="signupPosition">

                        <input class="sendSumPoint" type="hidden" name="highPoint" value=<%=user.getHighscore(user.getPlayer())%>>
                        <input class="sendSumPoint" type="hidden" name="lowPoint" value=<%=user.getLowscore(user.getPlayer())%>>
                        <input type="hidden" name="history1" value=<%=user.getId(user.getPlayer())%>>
                        <input type="hidden" name="history2" value="">
                        <input type="hidden" name="history3" value="">
                        <input type="hidden" name="history4" value="">
                        <input type="hidden" name="history5" value="">
                        <input type="hidden" name="point" value="">
                        <input type="submit" value="ゴールページへ" id="signupButton">
                    </div>

                </form>
            </article>
            <script>

                $(function () {

                    var moveOn; // 進んだますの格納
                    var preMove; // 1個前の進んだマスの格納
                    var firstMove; // サイコロを一回転がしたらtrue
                    var pointValue; // ポイント値
                    var position; // 画面のY座標
                    var processValue; // マスの値
                    var flip = false; // サイコロを振った
                    var randomMass; // サイコロの出目
                    var move40; // 40マス目の時、スクロースにエラーを出さないための変数
                    var pointArray = []; // 各ポイントを入れておく場所
                    var move40container;
                    var flipCount;

                    var arrayProcessValue = "";
                    var arrayPointValue = "";
                    var arrayRandomMass = "";
                    var arrayFlipCount = "";

                    // 初期化
                    function init() {
                        moveOn = 0;
                        preMove = 0;
                        firstMove = false;
                        pointValue = 0;
                        $("#point").text("00000pt");
                        position = 0;
                        $("html,body").animate({scrollTop: position});
                        processValue = 0;
                        $("#process").text("+0pt");
                        move40container = 0;
                        flipCount = 0;

                        arrayProcessValue = "";
                        arrayPointValue = "";
                        arrayRandomMass = "";
                        arrayFlipCount = "";
                        document.keisan.elements[3].value = "";
                        document.keisan.elements[4].value = "";
                        document.keisan.elements[5].value = "";
                        document.keisan.elements[6].value = "";
                        document.keisan.elements[7].value = "";

                        $("#signupButton").hide();

                    }

                    // 今いる場所の色を変える処理(場所, 前いた場所の色を戻す)
                    function nowPosition(now, rev) {
                        if (rev === false) { // 今いる場所の入りを変える
                            if (now % 10 === 0) {
                                $("#circle" + now).css("background-color", "#ffb31a");
                            } else if (now % 2 === 0) {
                                $("#circle" + now).css("background-color", "#ffb31a");
                            } else if (now % 2 === 1) {
                                $("#circle" + now).css("background-color", "#ffb31a");
                            }
                        } else if (rev === true) {
                            if (now % 10 === 0) { // 前いた場所の色を戻す
                                $("#circle" + now).css("background-color", "#fff");
                            } else if (now % 2 === 0) {
                                $("#circle" + now).css("background-color", "#fff");
                            } else if (now % 2 === 1) {
                                $("#circle" + now).css("background-color", "#fff");
                            }
                        }
                    }

                    init();

                    $(document).on('click', '#startButton', function () {

                        if (flip === false) { // サイコロを振り始める
                            $("#startButton p").text("サイコロを止める");
                            flip = true;

                            $("#saikoro")
                                    .text("") // この一行を入れると何個も画像が出ない
                                    // gifアニメーション開始
                                    .append('<img src="images/saikoroanimation.gif" class="saikoro">');
                        } else {
                            //document.sendhistory.elements[6].value = "サイコロを振る";
                            $("#startButton p").text("サイコロを振る");
                            flipCount++;
                            flip = false;

                            if (move40 === false) {
                                preMove = moveOn; // 一つ前のマスを格納\
                            } else {
                                preMove = move40container;
                            }
                            nowPosition(preMove, true); // (今いる場所, 前いた場所の色を戻す)
                            if (move40) { // 40マス目に
                                nowPosition(40, true);
                            }

                            randomMass = Math.floor(Math.random() * 6) + 1;
                            pointArray.push(randomMass);

                            moveOn += randomMass; // 進んだマス
                            if (firstMove === false) {
                                preMove = moveOn; // 一つ前のマス
                            }


                            // サイコロの画像の表示
                            function saikoroShow(randomMass) {
                                switch (randomMass) {
                                    case 1:
                                        $("#saikoro")
                                                .text("") // この一行を入れると何個も画像が出ない
                                                .append('<img src="images/saikoro1.png" class="saikoro">');
                                        break;
                                    case 2:
                                        $("#saikoro")
                                                .text("")
                                                .append('<img src="images/saikoro2.png" class="saikoro">');
                                        break;
                                    case 3:
                                        $("#saikoro")
                                                .text("")
                                                .append('<img src="images/saikoro3.png" class="saikoro">');
                                        break;
                                    case 4:
                                        $("#saikoro")
                                                .text("")
                                                .append('<img src="images/saikoro4.png" class="saikoro">');
                                        break;
                                    case 5:
                                        $("#saikoro")
                                                .text("")
                                                .append('<img src="images/saikoro5.png" class="saikoro">');
                                        break;
                                    case 6:
                                        $("#saikoro")
                                                .text("")
                                                .append('<img src="images/saikoro6.png" class="saikoro">');
                                        break;
                                }
                            }

                            saikoroShow(randomMass);// サイコロの画像の表示

                            move40 = false; // 40マス目の時、スクロースにエラーを出さないための変数

                            // ゴールしていない間実行
                            if (moveOn <= 50) {
                                // 今いる場所の色を変える
                                nowPosition(moveOn, false); // (今いる場所, 前いた場所の色を戻す)

                                processValue = 0;
                                // ポイントの計算
                                if (moveOn === 10) { // 10マス

                                    processValue = pointValue * 2;
                                    pointValue += processValue;
                                    $("#point").text(pointValue + "pt");
                                    alert("値が3倍になりました！");

                                } else if (moveOn === 20) { // 20マス

                                    processValue = Math.floor(Math.random() * 10000) - 10000;
                                    pointValue += processValue;
                                    $("#point").text(pointValue + "pt");
                                    alert(processValue + "pt増えました！");

                                } else if (moveOn === 30) { // 30マス

                                    processValue = 0;
                                    pointValue = processValue;
                                    $("#point").text(pointValue + "pt");
                                    alert("0ptになりました！");

                                } else if (moveOn === 40) { // 40マス

                                    move40container = moveOn;
                                    moveOn = 0;
                                    position = 0;
                                    processValue = 0;
                                    pointValue += processValue;
                                    $("#point").text(pointValue + "pt");
                                    move40 = true;
                                    alert("最初に戻りました！");
                                    $("html,body").animate({scrollTop: position});

                                } else if (moveOn === 50) { // 50マス

                                    processValue = -pointValue;
                                    pointValue = processValue;
                                    $("#point").text(pointValue + "pt");
                                    alert("合計値が+-逆転しました！");

                                } else if (moveOn % 2 === 0) { // マイナスマス

                                    processValue = -Math.floor(Math.random() * 1000) + 1;
                                    pointValue += processValue;
                                    $("#point").text(pointValue + "pt");

                                } else if (moveOn % 2 === 1) { // プラスマス

                                    processValue = Math.floor(Math.random() * 1000) + 1;
                                    pointValue += processValue;
                                    $("#point").text(pointValue + "pt");

                                }

                                // 画面スクロール
                                var hei = $(window).height(); // 画面の高さを取得
                                if (move40 !== true) { // 最初に戻る場合のマスに止まった場合以外
                                    position = $("#circle" + moveOn).offset().top - (hei / 2) + 50;
                                }
                                $("html,body").animate({scrollTop: position}); // スクロール

                                // 今いるマスのポイントを書き換える
                                if (processValue < 0) {
                                    $("#process").text(processValue + "pt");
                                } else if (processValue >= 0) {
                                    $("#process").text("+" + processValue + "pt");
                                }


                                arrayProcessValue = arrayProcessValue + processValue + ",";
                                arrayPointValue = arrayPointValue + pointValue + ",";
                                arrayRandomMass = arrayRandomMass + randomMass + ",";
                                arrayFlipCount = arrayFlipCount + flipCount + ",";
                                document.keisan.elements[3].value = arrayProcessValue; // 取得ポイント
                                document.keisan.elements[4].value = arrayPointValue; // 合計ポイント
                                document.keisan.elements[5].value = arrayRandomMass; // サイコロの出目
                                document.keisan.elements[6].value = arrayFlipCount; // サイコロの振った回数
                            } else {// 50マスを超えて進んだら
                                alert("ゴールに到達しました！");

                                //テキストボックスの数値を変数に格納する
                                var high = parseInt(document.keisan.elements[0].value);
                                var low = parseInt(document.keisan.elements[1].value);

                                if (high < pointValue) {
                                    alert("ハイスコア更新");
                                    document.keisan.elements[0].value = pointValue;
                                } else if (low > pointValue) {
                                    alert("ロースコア更新");
                                    document.keisan.elements[1].value = pointValue;
                                }
                                alert("ゴールページに行くボタンを押してください。");
                                $("#signupButton").show();
                                $("html,body").animate({scrollTop: position + 100});

                                document.keisan.elements[7].value = pointValue;

                                //window.location.href = "./4.jsp";
                                $.cookie("cPointArray", pointArray);
                                $.cookie("cSumPoint", pointValue);
                                //init(); // 初期化
                                pointArray = []; // リストの初期化

                            }
                        }



                        firstMove = true; // 一回目の行動を行った
                    });
                });
            </script>
            <footer></footer>
        </div><!-- container -->
    </body>
</html>
