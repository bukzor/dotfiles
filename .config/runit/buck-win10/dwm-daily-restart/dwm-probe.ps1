# Prints "<dwm age, minutes> <dwm VRAM, MB> <everyone else's VRAM, MB>".
# Readable non-elevated: Get-Process hides dwm's StartTime, CIM doesn't.
# VRAM is per-process dedicated usage; the adapter-level counter disagrees
# with it (~/claude/windows-forensics/papercuts.kb/vram-counters-disagree.md).
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'  # else CLIXML progress spam on stderr
$dwm = Get-CimInstance Win32_Process -Filter "Name='dwm.exe'" |
  Sort-Object CreationDate | Select-Object -First 1
$dwmPids = (Get-CimInstance Win32_Process -Filter "Name='dwm.exe'").ProcessId

$dwmBytes = 0; $otherBytes = 0
foreach ($s in (Get-Counter '\GPU Process Memory(*)\Dedicated Usage').CounterSamples) {
  if ($s.InstanceName -match 'pid_(\d+)') {
    if ([int]$Matches[1] -in $dwmPids) { $dwmBytes += $s.CookedValue }
    else { $otherBytes += $s.CookedValue }
  }
}
'{0:F0} {1:F0} {2:F0}' -f ((Get-Date) - $dwm.CreationDate).TotalMinutes,
  ($dwmBytes / 1MB), ($otherBytes / 1MB)
