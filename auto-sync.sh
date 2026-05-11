#!/bin/bash

REPO_DIR="/mnt/c/Users/cjh95/Desktop/준혁의_ai회사"
INTERVAL=10  # 10초마다 변경사항 확인

cd "$REPO_DIR"

echo "[auto-sync] 시작됨 - 변경사항을 자동으로 GitHub에 올립니다"

while true; do
    # 변경사항이 있는지 확인
    if ! git diff --quiet || ! git diff --cached --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
        TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
        echo "[auto-sync] $TIMESTAMP 변경사항 감지 → 커밋 중..."

        git add -A
        git commit -m "자동 저장: $TIMESTAMP"

        # post-commit 훅이 push 처리함
        echo "[auto-sync] GitHub 업로드 완료"
    fi

    sleep $INTERVAL
done
