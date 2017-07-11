/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ex15;

import java.sql.*; //SQLに関連したクラスライブラリをインポート

public class FortuneHistoryDB {

    /* フィールドの定義 */
    protected int[] fortuneHistoryId = new int[100]; //運勢履歴ID
    protected int[] userId = new int[100]; //ユーザーID
    protected int[] fortuneId = new int[100]; //運勢ID
    protected int num; //データ取得件数 

    /* メソッド */
 /* データベースからのデータ取得メソッド */
    public void dataload() throws Exception { //エラー処理が必要にする
/* 2.1.1 データベースに接続 */
        num = 0; //取得件数の初期化
        Class.forName("com.mysql.jdbc.Driver").newInstance(); //com.mysql.jdbc.Driverはドライバのクラス名
        String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8"; //データベース名：文字エンコードはUTF-8
        Connection conn = DriverManager.getConnection(url, "softd", "softd"); //上記URL設定でユーザ名とパスワードを使って接続

        /* 2.1.2 SELECT文の実行 */
        String sql = "SELECT * FROM fortunehistory"; //SQL文の設定 ?などパラメータが必要がない場合は通常のStatementを利用
        PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
        stmt.setMaxRows(100); //最大の数を制限
        ResultSet rs = stmt.executeQuery(); //ステートメントを実行しリザルトセットに代入

        /* 2.1.3 結果の取り出しと表示 */
        while (rs.next()) { //リザルトセットを1行進める．ない場合は終了
            this.fortuneHistoryId[num] = rs.getInt("運勢履歴ID");
            this.userId[num] = rs.getInt("ユーザーID");
            this.fortuneId[num] = rs.getInt("運勢ID");
            num++;
        }

        /* 2.1.4 データベースからの切断 */
        rs.close(); //開いた順に閉じる
        stmt.close();
        conn.close();
    }

    /* 2.2 データベースへのインサートメソッド */
    public int insert(int userId, int fortuneId) {
        int count = 0; //登録件数のカウント
        try {

            /* 2.2.1 データベースに接続 */
            Class.forName("com.mysql.jdbc.Driver").newInstance(); // SELECTの時と同じ
            String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8";
            Connection conn = DriverManager.getConnection(url, "softd", "softd");

            /* INSERT文の実行 */
            String sql = "INSERT INTO fortunehistory (ユーザーID, 運勢ID) VALUES (?, ?)"; //SQL文の設定 INSERTはパラメータが必要なことが多い

            PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
            stmt.setInt(1, userId); //1つ目の？に引数をセットする
            stmt.setInt(2, fortuneId); //2つ目の？に引数をセットする
/* 実行（UpdateやDeleteも同じメソッドを使う） */
            count = stmt.executeUpdate();

            /* データベースからの切断 */
            stmt.close();
            conn.close();
            return count;
        } catch (Exception e) {
            return 0;
        }
    }

    /* アクセッサ */
 /* Getアクセッサ */
    public int getFortuneHistoryId(int i) {
        if (i >= 0 && num > i) {
            return fortuneHistoryId[i];
        } else {
            return 0;
        }
    }

    public int getUserId(int i) {
        if (i >= 0 && num > i) {
            return userId[i];
        } else {
            return 0;
        }
    }

    public int getfortuneId(int i) {
        if (i >= 0 && num > i) {
            return fortuneId[i];
        } else {
            return 0;
        }
    }

    public int getNum() {
        return num; // データ件数
    }
}
