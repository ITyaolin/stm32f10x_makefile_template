#include "stm32f10x.h"

static __IO uint32_t TimingDelay;

void Delay(__IO uint32_t nTime)
{
    TimingDelay = nTime;
    while (TimingDelay != 0);
}

void SysTick_Handler(void)
{
    if (TimingDelay != 0x00)
        TimingDelay--;
}

int main(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;

    /* SysTick 1ms 中断 */
    if (SysTick_Config(SystemCoreClock / 1000))
        while (1);

    /* Enable GPIOC clock */
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

    /* Configure PC13 as push-pull output */
    GPIO_InitStructure.GPIO_Pin   = GPIO_Pin_13;
    GPIO_InitStructure.GPIO_Mode  = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOC, &GPIO_InitStructure);

    while (1) {
        GPIO_ResetBits(GPIOC, GPIO_Pin_13);   /* LED on  (active low) */
        Delay(1000);                           /* 1 second */
        GPIO_SetBits(GPIOC, GPIO_Pin_13);     /* LED off */
        Delay(1000);                           /* 1 second */
    }
}