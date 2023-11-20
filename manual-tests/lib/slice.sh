edit-tf() {
  cat > edit-me.tf <<EOF
resource "null_resource" "edit-me" {
  triggers = {
    now = "$NOW"
  }
}
EOF
}

edit-slice() {(
  slice_number="$1"
  cd slice-"$slice_number"*/
  edit-tf
)}

random-slices() {
  { echo "$((RANDOM % 3))"
    for slice in 0 1 2; do
      if ((RANDOM % 100 <= 33)); then
        edit-slice $slice
      fi
    done
  } | sort -u
}
