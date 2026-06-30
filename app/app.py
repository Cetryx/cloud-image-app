import os
from datetime import timezone

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
from flask import Flask, Response, flash, redirect, render_template, request, url_for
from werkzeug.utils import secure_filename


app = Flask(__name__)
app.secret_key = os.environ.get("FLASK_SECRET_KEY", "local-development-only")


def get_container_client():
    account_name = os.environ["AZURE_STORAGE_ACCOUNT_NAME"]
    container_name = os.environ["AZURE_STORAGE_CONTAINER_NAME"]
    managed_identity_client_id = os.environ.get("AZURE_CLIENT_ID")

    credential = DefaultAzureCredential(
        managed_identity_client_id=managed_identity_client_id
    )
    account_url = f"https://{account_name}.blob.core.windows.net"
    service_client = BlobServiceClient(account_url=account_url, credential=credential)
    return service_client.get_container_client(container_name)


@app.route("/")
def index():
    container_client = get_container_client()
    blobs = []

    for blob in container_client.list_blobs():
        last_modified = blob.last_modified
        if last_modified:
            last_modified = last_modified.astimezone(timezone.utc).strftime(
                "%Y-%m-%d %H:%M UTC"
            )

        blobs.append(
            {
                "name": blob.name,
                "size": blob.size or 0,
                "last_modified": last_modified,
            }
        )

    blobs.sort(key=lambda item: item["name"].lower())
    return render_template("index.html", blobs=blobs)


@app.route("/upload", methods=["GET", "POST"])
def upload():
    if request.method == "POST":
        uploaded_file = request.files.get("file")

        if not uploaded_file or not uploaded_file.filename:
            flash("Please choose a file before uploading.")
            return redirect(url_for("upload"))

        filename = secure_filename(uploaded_file.filename)
        if not filename:
            flash("The selected filename is not valid.")
            return redirect(url_for("upload"))

        container_client = get_container_client()
        blob_client = container_client.get_blob_client(filename)
        blob_client.upload_blob(uploaded_file.stream, overwrite=True)

        flash(f"Uploaded {filename}.")
        return redirect(url_for("index"))

    return render_template("upload.html")


@app.route("/download/<path:blob_name>")
def download(blob_name):
    container_client = get_container_client()
    blob_client = container_client.get_blob_client(blob_name)
    blob = blob_client.download_blob()

    return Response(
        blob.chunks(),
        mimetype="application/octet-stream",
        headers={
            "Content-Disposition": f'attachment; filename="{os.path.basename(blob_name)}"'
        },
    )


@app.route("/health")
def health():
    return {"status": "ok"}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "5000")), debug=True)
