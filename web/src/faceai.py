from dotenv import load_dotenv
import os
from google import genai
from pathlib import Path

# ファイル自体が関数になっている

def main():
    load_dotenv()
    api_key = os.getenv("AI_API_KEY")

    client = genai.Client(api_key=api_key)

    image_path = Path(r"/home/reiya/love-app/web/src/static/high_layered_short_cut.jpg")
    uploaded_file = client.files.upload(file=image_path)

    response = client.models.generate_content(
        model="gemini-2.5-pro-preview-06-05",
        contents = [
            uploaded_file,
            """
            You are an expert in facial feature analysis.
            Your task is to analyze a given face image (contents[0]) and determine its face shape by:

            1. Detect landmarks and compute distances:
            - Face length L (forehead center → chin tip)
            - Cheek width W_cheek (left cheekbone → right cheekbone)
            - Forehead width W_forehead (left temple → right temple)
            - Jaw width W_jaw (left jaw angle → right jaw angle)
            2. Calculate ratios:
            - R_face = W_cheek / L
            - R_jaw = W_jaw / W_cheek
            - R_forehead = W_forehead / W_cheek
            3. Classify using thresholds:
            - ホームベース型: R_face ≥ 1.178 and R_jaw ≥ 0.95
            - 逆三角形型: R_forehead ≥ 1.05 and R_jaw ≤ 0.80
            - 面長: 1.0537 ≤ R_face < 1.111
            - 丸顔: 1.112 ≤ R_face ≤ 1.176 and 0.85 ≤ R_jaw ≤ 0.95 and 0.95 ≤ R_forehead ≤ 1.05
            - 卵型: 1.112 ≤ R_face ≤ 1.176 and R_jaw ≤ 0.85 and R_forehead ≤ 1.05

            faceShapeList = ["丸顔", "面長", "ホームベース型", "卵型", "逆三角形型"]
            Answer only one Japanese label from the list, with no additional text.
            """
            ]
        )
    print(response.text)

if __name__=="__main__":
    main()