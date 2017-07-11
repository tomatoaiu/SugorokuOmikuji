/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ex15;

import java.sql.*; //SQLに関連したクラスライブラリをインポート

public class UserDB {

    /* フィールドの定義 */
    protected int[] id = new int[100]; //ユーザーID
    protected String[] name = new String[100]; //ユーザー名
    protected String[] password = new String[100]; //パスワード
    protected int[] highscore = new int[100]; //ハイスコア
    protected int[] lowscore = new int[100]; //ロースコア
    protected int num; //データ取得件数 

    private String toShowName = ""; // ログインの場合の名前表示

    private int playerNum = 0;

    /* メソッド */
 /* データベースからのデータ取得メソッド */
    public void dataload() throws Exception { //エラー処理が必要にする
/* データベースに接続 */
        num = 0; //取得件数の初期化
        Class.forName("com.mysql.jdbc.Driver").newInstance(); //com.mysql.jdbc.Driverはドライバのクラス名
        String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8"; //データベース名：文字エンコードはUTF-8
        Connection conn = DriverManager.getConnection(url, "softd", "softd"); //上記URL設定でユーザ名とパスワードを使って接続

        /* 2.1.2 SELECT文の実行 */ String sql = "SELECT * FROM user"; //SQL文の設定 ?などパラメータが必要がない場合は通常のStatementを利用
        PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
        stmt.setMaxRows(100); //最大の数を制限
        ResultSet rs = stmt.executeQuery(); //ステートメントを実行しリザルトセットに代入

        /* 2.1.3 結果の取り出しと表示 */
        while (rs.next()) { //リザルトセットを1行進める．ない場合は終了
            this.id[num] = rs.getInt("ユーザーID");
            this.name[num] = rs.getString("ユーザー名");
            this.password[num] = rs.getString("パスワード");
            this.highscore[num] = rs.getInt("ハイスコア");
            this.lowscore[num] = rs.getInt("ロースコア");
            num++;
        }

        //setToShowName(this.name[num - 1]); // 新規登録時の名前を表示するために代入しておく
        setPlayer(num - 1);

        /* 2.1.4 データベースからの切断 */
        rs.close(); //開いた順に閉じる
        stmt.close();
        conn.close();
    }

    /* データベースへのインサートメソッド */
    public int newinsert(String newid, String newpass) {
        int count = 0; //登録件数のカウント
        try {

            /* データベースに接続 */
            Class.forName("com.mysql.jdbc.Driver").newInstance(); // SELECTの時と同じ
            String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8";
            Connection conn = DriverManager.getConnection(url, "softd", "softd");

            /* INSERT文の実行 */
            String sql = "INSERT INTO user (ユーザー名, パスワード) VALUES (?, ?)"; //SQL文の設定 INSERTはパラメータが必要なことが多い

            PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
            stmt.setString(1, newid); //1つ目の？に引数をセットする
            stmt.setString(2, newpass); //2つ目の？に引数をセットする
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

    /* データベースへのアップデートメソッド */
    public int update(String name, String pass, String high, String low) throws Exception {
        int count = 0; //登録件数のカウント
        try {
            /* 2.4.1 データベースに接続 */
            Class.forName("com.mysql.jdbc.Driver").newInstance(); // SELECTの時と同じ
            String url = "jdbc:mysql://localhost/softd4?characterEncoding=UTF-8";
            Connection conn = DriverManager.getConnection(url, "softd", "softd");

            /* 2.4.2 UPDATE文の実行 */
            String sql = "UPDATE user SET ハイスコア=?, ロースコア=? WHERE ユーザー名=? and パスワード=?";

            PreparedStatement stmt = conn.prepareStatement(sql); //JDBCのステートメント（SQL文）の作成
            stmt.setString(1, high); //1つ目の？に引数をセットする
            stmt.setString(2, low); //２つ目の？に引数をセットする
            stmt.setString(3, name); //3つ目の？に引数をセットする
            stmt.setString(4, pass); //3つ目の？に引数をセットする

            count = stmt.executeUpdate();

            /* 2.4.4 データベースからの切断 */
            stmt.close();
            conn.close();
            return count;
        } catch (Exception e) {
            return 0;
        }
    }

    // ログインの名前とパスワードが合っているか確認
    public int loginNameMatch(String name, String pass) {
        try {
            dataload();
            for (int i = 0; i < getNum(); i++) {
                if (getName(i).equals(name) && getPassword(i).equals(pass)) {
                    //setToShowName(getName(i));
                    setPlayer(i);
                    return 0;
                }
            }
            return 1;
        } catch (Exception e) {
            return 1;
        }
    }

    
    public int newUserCheck(String name, String pass) {
        try {
            dataload();
            for (int i = 0; i < getNum(); i++) {
                if (getName(i).equals(name) && getPassword(i).equals(pass)) {
                    return 0;
                }
            }
            return 1;
        } catch (Exception e) {
            return 0;
        }
    }

    /* アクセッサ */
 /* Getアクセッサ */
    public int getId(int i) {
        if (i >= 0 && num > i) {
            return id[i];
        } else {
            return 0;
        }
    }

    public String getName(int i) {
        if (i >= 0 && num > i) {
            return name[i];
        } else {
            return "";
        }
    }

    public String getPassword(int i) {
        if (i >= 0 && num > i) {
            return password[i];
        } else {
            return "";
        }
    }

    public int getHighscore(int i) {
        if (i >= 0 && num > i) {
            return highscore[i];
        } else {
            return 0;
        }
    }

    public int getLowscore(int i) {
        if (i >= 0 && num > i) {
            return lowscore[i];
        } else {
            return 0;
        }
    }

    public int getNum() {
        return num; // データ件数
    }

    public void setPlayer(int playerNum) {
        this.playerNum = playerNum;
    }

    public int getPlayer() {
        return playerNum;
    }
}
