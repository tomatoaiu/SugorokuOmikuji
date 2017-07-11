<%@page contentType="text/html" pageEncoding="UTF-8"%>
<jsp:useBean id="user" scope="session" class="ex15.UserDB" />
<jsp:useBean id="fortune" scope="session" class="ex15.FortuneDB" />
<jsp:useBean id="history" scope="session" class="ex15.HistoryDB" />
<jsp:useBean id="fortuneHistory" scope="session" class="ex15.FortuneHistoryDB" />
<%
    
    int cnt = user.getPlayer();
    user.dataload();
    user.setPlayer(cnt);

    /* セッション内容の取得 */
    String point = "";
    if (session.getAttribute("point") != null) {
        point = session.getAttribute("point").toString();
    }
    try{
        fortune.matchfortune(Integer.parseInt(point));
    } catch(Exception e){%>
        <jsp:forward page="errorfortuneDB.jsp" />
    <%}
    fortuneHistory.insert(user.getId(user.getPlayer()), fortune.getFortuneId(0));
    
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>結果発表</title>
        <script src="js/jquery.js"></script>
        <script src="js/jquery.cookie.min.js"></script>
        <script src="js/d3.v3.min.js" charset="utf-8"></script>
        <link rel="stylesheet" type="text/css" href="css/4.css">

        <style>
            text {
                fill: #fff;
            }
        </style>

    </head>
    <body>
        <div id="container">
            <header>
                <h1>運勢</h1>
                <div id="sumPoint">sumPoint</div><br />
                <div id="fortune"></div><br />
                <div id="myGraphName">サイコロの出目の推移</div>
                <div id="myGraph"></div><br />
                <div id="myChartName">サイコロの出目の割合</div>
                <svg id="chart"></svg>

            </header>
            <div id="gSPosition">
                <a href="3.jsp" class="gameStart">もう一回遊ぶ</a><br />
            </div>
            <article>
                <script>
                    $(function () {
                        var array = $.cookie("cPointArray");
                        var list = [];
                        var percentage1 = 0;
                        var percentage2 = 0;
                        var percentage3 = 0;
                        var percentage4 = 0;
                        var percentage5 = 0;
                        var percentage6 = 0;
                        
                        
                        $("#sumPoint").text("合計は " + $.cookie("cSumPoint") + " ptです！");
                        for (var i = 0; i < array.length; i++) {
                            if (i % 2 === 0) {
                                list.push(array[i]);
                                switch (parseInt(array[i])) {
                                    case 1:
                                        percentage1++;
                                        break;
                                    case 2:
                                        percentage2++;
                                        break;
                                    case 3:
                                        percentage3++;
                                        break;
                                    case 4:
                                        percentage4++;
                                        break;
                                    case 5:
                                        percentage5++;
                                        break;
                                    case 6:
                                        percentage6++;
                                        break;
                                }
                            }
                        }
                        
                        var svgWidth = 64; // SVG領域の横幅
                        var svgHeight = 48;    // SVG領域の縦幅
                        var barHeight = 48;    // 棒グラフの基準位置
                        d3.select("#myGraph").append("svg")
                                .attr("width", svgWidth).attr("height", svgHeight)
                                .selectAll("rect")  // SVGでの四角形を示す要素を指定
                                .data(list) // データを設定
                                .enter()
                                .append("rect") // SVGでの四角形を示す要素を生成
                                .attr("x", function (d, i) {   // X座標を配列の順序に応じて計算
                                    return i * 18;
                                })
                                .attr("y", function (d) { // 縦幅を配列の内容に応じて計算
                                    return barHeight - (d * 6) + "px";
                                })
                                .attr("height", function (d) {    // 縦幅を配列の内容に応じて計算
                                    return (d * 6) + "px";
                                })
                                .attr("width", 17)  // 棒グラフの横幅を指定
                                .attr("style", "fill:rgb(255,0,0)"); // 棒グラフの色を赤色に設定
                        
                        $("#fortune").text("<%=user.getName(user.getPlayer())%>" + "さんの運勢は" + "<%= fortune.getFortune(0)%>" + "です！！");
                        
                        // サイズを設定
                        var size = {
                            width: 500,
                            height: 500
                        };
                        // 円グラフの表示データ
                        var data = [
                            {
                                legend: "count 1", value: percentage1, color: "#993300"
                            }, {
                                legend: "count 2", value: percentage2, color: "#FF6600"
                            }, {
                                legend: "count 3", value: percentage3, color: "#FFCC00"
                            }, {
                                legend: "count 4", value: percentage4, color: "#339966"
                            }, {
                                legend: "count 5", value: percentage5, color: "#33CCCC"
                            }, {
                                legend: "count 6", value: percentage6, color: "#0066CC"
                            }
                        ];
                        
                        
                        // d3用の変数
                        var win = d3.select(window), //←リサイズイベントの設定に使用します
                                svg = d3.select("#chart"),
                                pie = d3.layout.pie().sort(null).value(function (d) {
                            return d.value;
                        }),
                                arc = d3.svg.arc().innerRadius(40);
                        
                        // アニメーション終了の判定フラグ
                        var isAnimated = false;
                        
                        
                        // グラフの描画
                        // 描画処理に徹して、サイズに関する情報はupdate()内で調整する。
                        function render() {
                            
                            // グループの作成
                            var g = svg.selectAll(".arc")
                                    .data(pie(data))
                                    .enter()
                                    .append("g")
                                    .attr("class", "arc");
                            
                            // 円弧の作成
                            g.append("path")
                                    .attr("stroke", "white")
                                    .attr("fill", function (d) {
                                        return d.data.color;
                                    });
                            
                            // データの表示
                            var maxValue = d3.max(data, function (d) {
                                return d.value;
                            });
                            
                            g.append("text")
                                    .attr("dy", ".35em")
                                    .attr("font-size", function (d) {
                                        return d.value / maxValue * 20;
                                    }) //最大のサイズを20に
                                    .style("text-anchor", "middle")
                                    .text(function (d) {
                                        return d.data.legend;
                                    });
                        }
                        
                        
                        // グラフのサイズを更新
                        function update() {
                            
                            // 自身のサイズを取得する
                            size.width = parseInt(500);
                            size.height = parseInt(500); //←取得はしていますが、使用していません...
                            
                            // 円グラフの外径を更新
                            arc.outerRadius(size.width / 2);
                            
                            // 取得したサイズを元に拡大・縮小させる
                            svg
                                    .attr("width", size.width)
                                    .attr("height", size.width);
                            
                            // それぞれのグループの位置を調整
                            var g = svg.selectAll(".arc")
                                    .attr("transform", "translate(" + (size.width / 2) + "," + (size.width / 2) + ")");
                            
                            // パスのサイズを調整
                            // アニメーションが終了していない場合はサイズを設定しないように
                            if (isAnimated) {
                                g.selectAll("path").attr("d", arc);
                            }
                            
                            // テキストの位置を再調整
                            g.selectAll("text").attr("transform", function (d) {
                                return "translate(" + arc.centroid(d) + ")";
                            });
                        }
                        
                        
                        // グラフのアニメーション設定
                        function animate() {
                            var g = svg.selectAll(".arc"),
                                    length = data.length,
                                    i = 0;
                            
                            g.selectAll("path")
                                    .transition()
                                    .ease("cubic-out")
                                    .delay(500)
                                    .duration(1000)
                                    .attrTween("d", function (d) {
                                        var interpolate = d3.interpolate(
                                                {startAngle: 0, endAngle: 0},
                                                {startAngle: d.startAngle, endAngle: d.endAngle}
                                        );
                                        return function (t) {
                                            return arc(interpolate(t));
                                        };
                                    })
                                    .each("end", function (transition, callback) {
                                        i++;
                                        isAnimated = i === length; //最後の要素の時だけtrue
                                    });
                        }
                        
                        
// 初期化
                        render();
                        update();
                        animate();
                        win.on("resize", update); // ウィンドウのリサイズイベントにハンドラを設定
                        
                    });
                </script>
            </article>
            <nav></nav>
            <footer></footer>
        </div><!-- container -->
    </body>
</html>
