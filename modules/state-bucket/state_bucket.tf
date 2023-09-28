# Create new multi-region storage bucket in the US
# with versioning enabled

# [START storage_kms_encryption_tfstate]
resource "google_kms_key_ring" "terraform_state" {
  name     = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  location = "us"
}

resource "google_kms_crypto_key" "terraform_state_bucket" {
  name            = "terraform-state-bucket"
  key_ring        = google_kms_key_ring.terraform_state.id
  rotation_period = "86400s"

  lifecycle {
    prevent_destroy = false
  }
}

# Create service account to be used for KMS
# Enable the Cloud Storage service account to encrypt/decrypt Cloud KMS keys
data "google_project" "project" {
}

resource "google_service_account" "sa-kms" {
  account_id   = "service-${data.google_project.project.number}"
  display_name = "sa-terraform"
}

resource "google_project_iam_member" "default" {
  project  = data.google_project.project.project_id
  for_each = toset(["roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/storage.objectUser"])
  role     = each.key
  member   = "serviceAccount:service-${data.google_project.project.number}@${data.google_project.project.name}.iam.gserviceaccount.com"
}

# To randomize naming
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

# Grant GCS default service account permission to KMS
data "google_storage_project_service_account" "gcs_account" {
}

resource "google_kms_key_ring_iam_binding" "key_ring" {
  key_ring_id = google_kms_key_ring.terraform_state.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
    "serviceAccount:service-${data.google_project.project.number}@${data.google_project.project.name}.iam.gserviceaccount.com"
  ]
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  crypto_key_id = google_kms_crypto_key.terraform_state_bucket.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}",
    "serviceAccount:service-${data.google_project.project.number}@${data.google_project.project.name}.iam.gserviceaccount.com"
  ]
}

# Create a gcs bucket to store state so it will not be stored locally
resource "google_storage_bucket" "state_bucket" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = false
  location      = var.region
  storage_class = var.class
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  }
  depends_on = [
    google_service_account.sa-kms,
    google_project_iam_member.default
  ]
}