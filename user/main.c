#include "stm32f10x.h"

void Delay(__IO uint32_t nCount)
{
    for (; nCount != 0; nCount--);
}

int main(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;

    /* Enable GPIOC clock */
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);

    /* Configure PC13 as push-pull output */
    GPIO_InitStructure.GPIO_Pin   = GPIO_Pin_13;
    GPIO_InitStructure.GPIO_Mode  = GPIO_Mode_Out_PP;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(GPIOC, &GPIO_InitStructure);

    while (1) {
        GPIO_ResetBits(GPIOC, GPIO_Pin_13);   /* LED on  (active low) */
        Delay(500000);
        GPIO_SetBits(GPIOC, GPIO_Pin_13);     /* LED off */
        Delay(500000);
    }
}
