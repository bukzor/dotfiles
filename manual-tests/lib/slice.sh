#!/sourceme/bash


_edit-tf() {
  cat > edit-me.tf <<EOF
resource "null_resource" "edit-me" {
  triggers = {
    now = "$NOW"
  }
}
EOF
  git add edit-me.tf
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
        echo $slice
      fi
    done
  } | sort -u
}

slice::edit-random() {
  random_slice=$(slice::random)
  read -r -a slices <<< "$random_slice"
  for slice in "${slices[@]}"; do
    slice::edit "$slice"
  done
  echo "$random_slice"
}

slice::assert-locked() {
  : FIXME: perform a real assertion here
  if true; then
    return 0
  else
    (
      slice_number="$1"
      cd slice-"$slice_number"*/ || return 1
      if ! terraform plan --lock=true; then
        : ok
      else
        echo >&2 "AssertionError: slice $slice_number should be locked!"
        return 1
      fi
    )
  fi
}

slice::assert-not-locked() {
  : FIXME: perform a real assertion here
  if true; then
    return 0
  else
    ! assert-locked "$1"
  fi
}
