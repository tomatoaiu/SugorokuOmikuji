/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ex15;

import java.sql.*; //SQLに関連したクラスライブラリをインポート

public class FortuneDB {

    /* フィールドの定義 */
    protected int[] fortuneId = new int[100]; //運勢ID
    protected String[] fortune = new String[100]; //運勢名
    protected int num; //データ取得件数 

    private int playerNum = 0;

    /* メソッド */
    /* データベースからのデータ取得メソッド */
    public void matchfortune(int point) throws Exception { //エラー処理が必要にする
    /* データベースに接続 */
        num = 0; //取得件数の初期化
        Class.forName("com.mysql.jdbc.Driver").newInstance(); //com.mysql.jdbc.Driverはドライバのクラス名
        String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8"; //データベース名：文字エンコードはUTF-8
        Connection conn = DriverManager.getConnection(url, "softd", "softd"); //上記URL設定でユーザ名とパスワードを使って接続

        /* 2.1.2 SELECT文の実行 */
        String sql = "SELECT 運勢ID, 運勢名 FROM fortune where 最低値 <= ? and 最高値 >= ?"; //SQL文の設定 ?などパラメータが必要がない場合は通常のStatementを利用
        PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
        stmt.setInt(1, point); //1つ目の？に引数をセットする
        stmt.setInt(2, point); //２つ目の？に引数をセットする

        stmt.setMaxRows(100); //最大の数を制限

        ResultSet rs = stmt.executeQuery(); //ステートメントを実行しリザルトセットに代入

        /* 2.1.3 結果の取り出しと表示 */
        while (rs.next()) { //リザルトセットを1行進める．ない場合は終了
            this.fortuneId[num] = rs.getInt("運勢ID");
            this.fortune[num] = rs.getString("運勢名");
            num++;
        }

        /* 2.1.4 データベースからの切断 */
        rs.close(); //開いた順に閉じる
        stmt.close();
        conn.close();
    }


    /* アクセッサ */
    /* Getアクセッサ */
    public int getFortuneId(int i) {
        if (i >= 0 && num > i) {
            return fortuneId[i];
        } else {
            return 0;
        }
    }
    
    public String getFortune(int i) {
        if (i >= 0 && num > i) {
            return fortune[i];
        } else {
            return "";
        }
    }

    public int getNum() {
        return num; // データ件数
    }
}
