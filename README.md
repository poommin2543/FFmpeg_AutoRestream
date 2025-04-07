
# FFmpeg Auto Stream & Restart when internet lost connection

This project is designed to **automatically start live streaming video when the system boots up**, and **automatically restart the stream if it stops**, such as when internet connectivity is lost. It is ideal for unattended streaming systems like Raspberry Pi with a connected camera.

---

## Project Purpose

The goal of this project is to provide:
- ✅ **Automatic streaming** on boot using `systemd`
- 🔁 **Self-recovery** from stream interruptions (e.g. internet disconnection, ffmpeg crash)
- 🛠️ **Lightweight monitoring** using shell scripts

This ensures a reliable and hands-free video streaming setup for remote monitoring or broadcasting applications.

---

## Components

- `ffmpeg.sh`: Launches FFmpeg to stream video from a local camera using RTMP.
- `monitor_stream.sh`: Continuously checks if the stream is frozen. If so, it kills and restarts FFmpeg.
- `stream_service.service`: A systemd service file that ensures `monitor_stream.sh` starts automatically on boot.

---

## Requirements

- A Linux-based system (e.g., Raspberry Pi)
- FFmpeg installed
- Camera device available at `/dev/video0`
- UUID file located at `/home/pi/legacy_uuid_get_script/legacy_uid.txt`
- Permission to run shell scripts

---

## Installation and Setup

1. **Clone this repository**:
   ```bash
   git clone <repository_url>
   cd <repository_directory>
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x ffmpeg.sh monitor_stream.sh
   ```

3. **Move scripts to target directory** (e.g., `/home/pi/`):
   ```bash
   cp ffmpeg.sh monitor_stream.sh /home/pi/
   ```

4. **Verify UUID file** exists at:
   ```
   /home/pi/legacy_uuid_get_script/legacy_uid.txt
   ```

---

## Auto-Start Setup with systemd

To ensure streaming starts automatically on boot:

1. **Place the service file** in systemd directory:
   ```bash
   sudo cp stream_service.service /etc/systemd/system/
   ```

2. **(Optional)**: Edit the service file to match the actual path:
   ```ini
   [Service]
   ExecStart=/home/pi/monitor_stream.sh
   ```

3. **Reload systemd** to detect the new service:
   ```bash
   sudo systemctl daemon-reload
   ```

4. **Enable the service** so it starts at boot:
   ```bash
   sudo systemctl enable stream_service.service
   ```

5. **Start the service now** (or just reboot):
   ```bash
   sudo systemctl start stream_service.service
   ```

6. **Check service status**:
   ```bash
   sudo systemctl status stream_service.service
   ```

---

## How It Works

- On boot, `stream_service.service` launches `monitor_stream.sh`
- `monitor_stream.sh` checks if `ffmpeg` is running. If not, it runs `ffmpeg.sh`
- Every few seconds, it checks for frame count change in `ffmpeg_stream.log`
- If the count is unchanged (indicating a frozen stream), it restarts FFmpeg

---

## Logs

- Stream Log: `/home/pi/stream.log`
- FFmpeg Log: `/home/pi/ffmpeg_stream.log`

---

## Customization

- Change `RTMP` destination by modifying the `RTMP_URL` in `ffmpeg.sh`
- Adjust logging paths, frame rate, resolution, encoding quality as needed
- Modify sleep intervals in `monitor_stream.sh` for quicker/slower checks

---

## License

MIT License — Free for personal and commercial use

---

## Contributions

Pull requests and suggestions are welcome! Help improve and adapt this tool to more use cases.

---

## Contact
For questions, suggestions, or issues, please contact:
Email: poommin2543@gmail.com

---

Stay streaming. Stay stable. 📹🌐🛠️
