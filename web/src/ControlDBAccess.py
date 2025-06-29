import mysql.connector
from mysql.connector import Error
import os

#ローカルの場合はこっち
# #データベースの接続
# def createConnection():
#     try:
#         connection = mysql.connector.connect(
#             host='db',
#             database='loveapp',
#             user='loveuser',
#             password='lovepass',
#             charset='utf8mb4',
#             use_unicode=True
#         )
#         connection.set_charset_collation('utf8mb4', 'utf8mb4_unicode_ci')
#         if connection.is_connected():
#             #connection.set_charset_collation('utf8mb4')  # ←追加！
#             return connection
#         else:
#             print("データベース接続に失敗しました。")
#             return None
#     except Error as e:
#         print(f"データベース接続エラー: {e}")
#         return None

#GCP用
def createConnection():
    try:
        connection = mysql.connector.connect(
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASS"),
            database=os.environ.get("DB_NAME"),
            unix_socket=f'/cloudsql/{os.environ.get("DB_HOST")}',  # 🔴 ここが重要！
            charset='utf8mb4',
            use_unicode=True
        )
        if connection.is_connected():
            print("✅ Cloud SQL に接続成功")
            return connection
    except Exception as e:
        print(f"❌ DB接続失敗: {e}")
    return None

    
    
#登録情報をデータベースに登録するプログラム
def insertUser(user_id, name, password):
    connection = createConnection()#データベースの接続
    cursor = connection.cursor()  #データベースにSQL命令を出すためのオブジェクト

    try:
        
        sql = "INSERT INTO users (user_id, name, password) VALUES (%s, %s, %s)"
        cursor.execute(sql, (user_id, name, password)) #VALUES (%s, %s, %s)に値を入れている
        connection.commit()#sqlを実行
    except mysql.connector.Error as err:
        print("エラー:", err)
    finally:
        cursor.close()
        connection.close()

#ログイン情報を照合するプログラム
def authenticate_user(user_id, password):
    connection = createConnection()#データベースの接続
    if not connection:
        return None
    cursor = connection.cursor(dictionary=True) #SQLの実行結果を辞書型（dict型）で受け取れるようにする

    try:
        sql = "SELECT user_name FROM Users WHERE user_id = %s AND password = %s"
        cursor.execute(sql, (user_id, password)) #　%sに代入
        result = cursor.fetchone() #SQLの実行結果の中から「最初の1行だけ」を取り出す

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
    connection = createConnection()#データベースの接続
    
    if connection is None:
        return None, None  # 接続できなかった場合

    try:
        cursor = connection.cursor(dictionary=True) #SQLの実行結果を辞書型（dict型）で受け取れるようにする
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
        # query = """
        # SELECT
        #     fs.face_shape_id,
        #     fs.face_shape_name
        # FROM
        #     loveapp.FaceShapes AS fs
        # """

        cursor.execute(query, (face_shape,))
        print("2:",face_shape)
        result = cursor.fetchone()  # 顔型にマッチするデータを1件取得
        
       # 必要に応じて読み残しを回収
        while cursor.nextset():
            pass
        print("3:",result)
        if result:
            print("3:",result)
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

