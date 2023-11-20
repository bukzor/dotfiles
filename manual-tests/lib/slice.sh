#!/sourceme/bash


_edit-tf() {
  cat > edit-me.tf <<EOF
resource "null_resource" "edit-me" {
  triggers = {
    now = "$NOW"
  }
}
EOF
}

slice::edit() {
  (
     slice_number="$1"
     cd slice-"$slice_number"*/ || return 1
     _edit-tf
  )
}

slice::random() {
  { echo "$((RANDOM % 3))"
    for slice in 0 1 2; do
      if ((RANDOM % 100 <= 33)); then
        edit-slice $slice
      fi
    done
  } | sort -u
}

slice::assert-locked() {(
  slice_number="$1"
  cd slice-"$slice_number"*/ || return 1
  if ! terraform plan --lock=true; then
    : ok
  else
    echo >&2 "AssertionError: slice $slice_number should be locked!"
    return 1
  fi
)}
