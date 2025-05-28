import mysql.connector
from mysql.connector import Error
#データベースの接続
def createConnection():
    try:
        connection = mysql.connector.connect(
            host='db',
            database='loveapp',
            user='loveuser',
            password='lovepass'
        )
        if connection.is_connected():
            return connection
        else:
            print("データベース接続に失敗しました。")
            return None
    except Error as e:
        print(f"データベース接続エラー: {e}")
        return None
    
    
#登録情報をデータベースに登録するプログラム
def insertUser(user_id, name, password):
    connection = createConnection()
    cursor = connection.cursor()

    try:
        sql = "INSERT INTO users (user_id, name, password) VALUES (%s, %s, %s)"
        cursor.execute(sql, (user_id, name, password))
        connection.commit()
    except mysql.connector.Error as err:
        print("エラー:", err)
    finally:
        cursor.close()
        connection.close()

#ログイン情報を照合するプログラム
def authenticate_user(user_id, password):
    connection = createConnection()
    if not connection:
        return None

    cursor = connection.cursor(dictionary=True)

    try:
        sql = "SELECT user_name FROM Users WHERE user_id = %s AND password = %s"
        cursor.execute(sql, (user_id, password))
        result = cursor.fetchone()

        if result:
            return result['name']  # 名前を返す
        else:
            return None  # ユーザーIDかパスワードが間違っている
    except mysql.connector.Error as err:
        print("エラー:", err)
        return None
    finally:
        cursor.close()
        connection.close()
        
    

    
#顔型から髪型を返すプログラム
def getHairstyle(face_shape):
    connection = createConnection()
    
    if connection is None:
        return None, None  # 接続できなかった場合

    try:
        cursor = connection.cursor(dictionary=True)  # 結果を辞書形式で取得
        query = """
            SELECT
            h.hairstyle_name,    -- 髪型の名前
            h.hair_image_path    -- 画像ファイルのパス
            FROM
            loveapp.FaceShapes        AS fs
            INNER JOIN loveapp.FaceShape_Hairstyle AS fsh
            ON fs.face_shape_id = fsh.face_shape_id
            INNER JOIN loveapp.Hairstyles       AS h
            ON fsh.hairstyle_id   = h.hairstyle_id
            WHERE
            fs.face_shape_name = %s
            """
        cursor.execute(query, (face_shape,))
        result = cursor.fetchone()  # 顔型にマッチするデータを1件取得

        if result:
            hairstyle = result['hairstyle_name']
            image_path = result['hair_image_path']
            return hairstyle, image_path
        else:
            print("指定された顔型に一致する髪型が見つかりませんでした。")
            return None, None

    except Error as e:
        print(f"データベースクエリエラー: {e}")
        return None, None

    finally:
        if connection.is_connected():
            cursor.close()  # 先にcursorを閉じる
            connection.close()  # その後に接続を閉じる

