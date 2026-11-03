/*
 * P-A-R-T LED identification node: safe bring-up and test firmware.
 * ESP-IDF, ESP32-C3. UART commands: STATUS, IDENTIFY, HELP.
 * Deliberately NO RF, BLE, actuator, heater, high-power output or timer.
 * Replace LED GPIO with the documented on-board LED GPIO for your board.
 */
#include <stdio.h>
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"
#include "driver/uart.h"
#include "esp_log.h"

#define IDENT_LED_GPIO GPIO_NUM_8
#define COMMAND_BUF 64
static const char *TAG = "PART_LED";

static void blink_identify(void) {
    for (int i = 0; i < 3; ++i) {
        gpio_set_level(IDENT_LED_GPIO, 1);
        vTaskDelay(pdMS_TO_TICKS(120));
        gpio_set_level(IDENT_LED_GPIO, 0);
        vTaskDelay(pdMS_TO_TICKS(120));
    }
}
void app_main(void) {
    gpio_config_t io = {
        .pin_bit_mask = 1ULL << IDENT_LED_GPIO,
        .mode = GPIO_MODE_OUTPUT,
        .pull_up_en = GPIO_PULLUP_DISABLE,
        .pull_down_en = GPIO_PULLDOWN_DISABLE,
        .intr_type = GPIO_INTR_DISABLE,
    };
    ESP_ERROR_CHECK(gpio_config(&io));
    gpio_set_level(IDENT_LED_GPIO, 0);
    ESP_ERROR_CHECK(uart_driver_install(UART_NUM_0, 1024, 0, 0, NULL, 0));
    ESP_LOGI(TAG, "PART node ready; LED-only; no wireless/actuator capability");
    char line[COMMAND_BUF] = {0};
    size_t pos = 0;
    for (;;) {
        unsigned char c;
        int n = uart_read_bytes(UART_NUM_0, &c, 1, pdMS_TO_TICKS(50));
        if (n <= 0) continue;
        if (c == '\n' || c == '\r') {
            line[pos] = 0;
            if (strcmp(line, "IDENTIFY") == 0) {
                ESP_LOGI(TAG, "IDENTIFY: LED blink");
                blink_identify();
            } else if (strcmp(line, "STATUS") == 0) {
                ESP_LOGI(TAG, "STATUS: READY_LED_ONLY");
            } else if (strcmp(line, "HELP") == 0) {
                ESP_LOGI(TAG, "Commands: STATUS, IDENTIFY, HELP");
            } else if (pos != 0) {
                ESP_LOGW(TAG, "UNKNOWN: command ignored");
            }
            pos = 0;
        } else if (pos + 1 < sizeof(line)) {
            line[pos++] = (char)c;
        } else {
            pos = 0; // discard oversized input
            ESP_LOGW(TAG, "Oversized command rejected");
        }
    }
}
