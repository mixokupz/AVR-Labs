/*
 * lab6C.c - USART with Interrupts
 */

#define F_CPU 16000000UL
#define BAUD_RATE 9600
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

#define BUFFER_SIZE 64

volatile char rx_buffer[BUFFER_SIZE];
volatile int rx_index = 0;
volatile char data_ready = 0;

void usart_init(void)
{
    // Включаем приемник, передатчик и прерывание по приему
    UCSR0B = (1<<TXEN0) | (1<<RXEN0) | (1<<RXCIE0);
    
    UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);
    
    UBRR0L = F_CPU/16/BAUD_RATE - 1;
    UBRR0H = 0;
    
    sei();  // Глобально разрешаем прерывания
}

ISR(USART_RX_vect)
{
    char c = UDR0;  // Читаем принятый байт
    
    if (c == '\n' || c == '\r')
    {
        rx_buffer[rx_index] = '\0';  // Завершаем строку
        data_ready = 1;               // Сигнал что данные готовы
        rx_index = 0;
    }
    else if (rx_index < BUFFER_SIZE - 1)
    {
        rx_buffer[rx_index] = c;      // Сохраняем в буфер
        rx_index++;
        
        // Эхо (опционально)
        while (!(UCSR0A & (1<<UDRE0)));
        UDR0 = c;
    }
}

void usart_sendStr(char str)
{
    while (!(UCSR0A & (1<<UDRE0)));
    UDR0 = str;
}

int main(void)
{
    usart_init();
    
    usart_sendStr("A");
    
}