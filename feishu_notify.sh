#!/bin/bash

# 参数获取
WEBHOOK_URL="$1"
TITLE="$2"
CONTENT="$3"

# 飞书通知
send_feishu_notification() {
    local message=$(jq -n \
        --arg title "$TITLE" \
        --arg text "$CONTENT" \
        '{
            msg_type: "post",
            content: {
                post: {
                    zh_cn: {
                        title: $title,
                        content: [[{
                            tag: "text",
                            text: $text
                        }]]
                    }
                }
            }
        }'
    )
    curl -s -X POST "$WEBHOOK_URL" -H "Content-Type: application/json" -d "$message"
}

# 主函数
main() {
    if [ -z "$WEBHOOK_URL" ] || [ -z "$TITLE" ] || [ -z "$CONTENT" ]; then
        echo "错误: 缺少必要的飞书通知参数"
        exit 1
    fi
    send_feishu_notification
}

main "$@"
