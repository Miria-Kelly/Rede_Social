from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload
from google.oauth2.credentials import Credentials
from google.auth.transport.requests import Request
import os

SCOPES = ["https://www.googleapis.com/auth/drive.file"]
PASTA_ID = "1thG5qmYCU-LeYX-37Uu92o_1iA87UfIn"


def contatoDrive():
    creds = None

    if os.path.exists("drive/token.json"):
        creds = Credentials.from_authorized_user_file(
            "drive/token.json", SCOPES
        )

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            raise Exception(
                "Token inválido ou ausente. Gere o token fora do Docker."
            )

    service = build('drive', 'v3', credentials=creds)
    return service



def upload_google_drive(caminho_arquivo):
    service = contatoDrive()

    file_metadata = {
        "name": os.path.basename(caminho_arquivo),
        "parents": [PASTA_ID]
    }

    media = MediaFileUpload(caminho_arquivo, resumable=True)

    file = service.files().create(
        body=file_metadata,
        media_body=media,
        fields="id"
    ).execute()

    file_id = file.get("id")

    # deixa público
    service.permissions().create(
        fileId=file_id,
        body={"type": "anyone", "role": "reader"}
    ).execute()

    return f"https://drive.google.com/uc?id={file_id}"
