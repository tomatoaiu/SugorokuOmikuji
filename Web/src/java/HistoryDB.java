/*
    HistoryDBに接続
 */
package ex15;

import java.sql.*; //SQLに関連したクラスライブラリをインポート

public class HistoryDB {

    /* 1. フィールドの定義 */
    protected int[] historyId = new int[100]; //履歴ID
    protected int[] userId = new int[100]; //ユーザーID
    protected int[] point = new int[100]; //取得ポイント
    protected int[] sumPoint = new int[100]; //合計ポイント
    protected int[] saikoro = new int[100]; //サイコロの出目
    protected int[] flipCount = new int[100]; //サイコロの振った回数

    protected int num; //データ取得件数 

    /* メソッド */
 /* データベースからのデータ取得メソッド */
    public void dataload() throws Exception { //エラー処理が必要にする
        /* データベースに接続 */
        num = 0; //取得件数の初期化
        Class.forName("com.mysql.jdbc.Driver").newInstance(); //com.mysql.jdbc.Driverはドライバのクラス名
        String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8"; //データベース名：文字エンコードはUTF-8
        Connection conn = DriverManager.getConnection(url, "softd", "softd"); //上記URL設定でユーザ名とパスワードを使って接続

        /* 2.1.2 SELECT文の実行 */ String sql = "SELECT * FROM history"; //SQL文の設定 ?などパラメータが必要がない場合は通常のStatementを利用
        PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
        stmt.setMaxRows(100); //最大の数を制限
        ResultSet rs = stmt.executeQuery(); //ステートメントを実行しリザルトセットに代入

        /* 2.1.3 結果の取り出しと表示 */
        while (rs.next()) { //リザルトセットを1行進める．ない場合は終了
            this.historyId[num] = rs.getInt("履歴ID");
            this.userId[num] = rs.getInt("ユーザーID");
            this.point[num] = rs.getInt("取得ポイント");
            this.sumPoint[num] = rs.getInt("合計ポイント");
            this.saikoro[num] = rs.getInt("サイコロの出目");
            this.flipCount[num] = rs.getInt("サイコロの振った回数");
            num++;
        }

        /* 2.1.4 データベースからの切断 */
        rs.close(); //開いた順に閉じる
        stmt.close();
        conn.close();
    }

    /* データベースへのインサートメソッド */
    public int insert(String id, String point, String sumpoint, String saikoro, String flipcount) {
        int count = 0; //登録件数のカウント
        try {

            /* 2.2.1 データベースに接続 */
            Class.forName("com.mysql.jdbc.Driver").newInstance(); // SELECTの時と同じ
            String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8";
            Connection conn = DriverManager.getConnection(url, "softd", "softd");

            /* 2.2.2 INSERT文の実行 */
            //SQL文の設定 INSERTはパラメータが必要なことが多い
            String sql = "INSERT INTO history (ユーザーID, 取得ポイント, 合計ポイント, サイコロの出目, サイコロの振った回数) VALUES (?, ?, ?, ?, ?)";

            PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
            stmt.setString(1, id); //1つ目の？に引数をセットする
            stmt.setString(2, point); //2つ目の？に引数をセットする
            stmt.setString(3, sumpoint); //3つ目の？に引数をセットする
            stmt.setString(4, saikoro); //4つ目の？に引数をセットする
            stmt.setString(5, flipcount); //5つ目の？に引数をセットする
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
    public int getHistoryId(int i) {
        if (i >= 0 && num > i) {
            return historyId[i];
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

    public int getPoint(int i) {
        if (i >= 0 && num > i) {
            return point[i];
        } else {
            return 0;
        }
    }

    public int getSumPoint(int i) {
        if (i >= 0 && num > i) {
            return sumPoint[i];
        } else {
            return 0;
        }
    }

    public int getSaikoro(int i) {
        if (i >= 0 && num > i) {
            return saikoro[i];
        } else {
            return 0;
        }
    }

    public int getFlipCount(int i) {
        if (i >= 0 && num > i) {
            return flipCount[i];
        } else {
            return 0;
        }
    }

    public int getNum() {
        return num; // データ件数
    }
}
