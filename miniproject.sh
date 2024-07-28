
#!/bin/bash

# Variables and Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
EMAIL_TO="andrewkrithick50809@gmail.com"
EMAIL_FROM="andrewskrithick50809@gmail.com"
SMTP_SERVER="andrewskrithick50809@gmail.com"
SMTP_PORT="587"

# Functions
check_cpu() {
  local cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  if [ $cpu_usage -gt $CPU_THRESHOLD ]; then
    echo "CPU usage is high: $cpu_usage%"
    send_email "CPU Alert" "CPU usage is high: $cpu_usage%"
  fi
}

check_mem() {
  local mem_usage=$(free -m | awk '/Mem/ {print $3/$2 * 100}')
  if [ $mem_usage -gt $MEM_THRESHOLD ]; then
    echo "Memory usage is high: $mem_usage%"
    send_email "Memory Alert" "Memory usage is high: $mem_usage%"
  fi
}

check_disk() {
  local disk_usage=$(df -h | awk '/\/$/ {print $5}' | tr -d '%')
  if [ $disk_usage -gt $DISK_THRESHOLD ]; then
    echo "Disk usage is high: $disk_usage%"
    send_email "Disk Alert" "Disk usage is high: $disk_usage%"
  fi
}

check_logins() {
  local suspicious_logins=$(last -n 10 | grep -E "invalid|failed" | wc -l)
  if [ $suspicious_logins -gt 5 ]; then
    echo "Suspicious login attempts detected: $suspicious_logins"
    send_email "Login Alert" "Suspicious login attempts detected: $suspicious_logins"
  fi
}

check_users_groups() {
  local new_users=$(getent passwd | wc -l)
  local new_groups=$(getent group | wc -l)
  if [ $new_users -gt 0 ] || [ $new_groups -gt 0 ]; then
    echo "New users or groups detected: $new_users users, $new_groups groups"
    send_email "User/Group Alert" "New users or groups detected: $new_users users, $new_groups groups"
  fi
}

check_system_files() {
  local changed_files=$(find /etc /bin /sbin /usr/bin /usr/sbin -type f -mtime -1 | wc -l)
  if [ $changed_files -gt 0 ]; then
    echo "Changes detected to system files: $changed_files files"
    send_email "File Alert" "Changes detected to system files: $changed_files files"
  fi
}

check_open_ports() {
  local open_ports=$(netstat -tlnp | grep LISTEN | wc -l)
  if [ $open_ports -gt 10 ]; then
    echo "Open ports detected: $open_ports"
    send_email "Port Alert" "Open ports detected: $open_ports"
  fi
}

send_email() {
  local subject=$1
  local body=$2
  echo "Sending email: $subject"
  echo "$body" | mail -s "$subject" -r "$EMAIL_FROM" "$EMAIL_TO"
}

# Main Script
echo "System Monitoring Report"
echo "------------------------"
check_cpu
check_mem
check_disk
echo "System Security Report"
echo "------------------------"
check_logins
check_users_groups
check_system_files
check_open_ports

