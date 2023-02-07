#include "iob-gpio.h"

//GPIO functions

//Set GPIO base address
void gpio_init(int base_address){
  IOB_GPIO_INIT_BASEADDR(base_address);
}
uint32_t gpio_sensor_i_get(){
  return IOB_GPIO_GET_INPUT_SENSOR_I();
}

uint32_t gpio_sensor_o_get(){
  return IOB_GPIO_GET_INPUT_SENSOR_O();
}

uint32_t gpio_sensor_get(){
  return IOB_GPIO_GET_INPUT_SENSOR_GENERAL();
}
//Get values from inputs
uint32_t gpio_get(){
  return IOB_GPIO_GET_INPUT();
}

//Set values on outputs
void gpio_set(uint32_t value){
  IOB_GPIO_SET_OUTPUT(value);
}

//Set mask for outputs (bits 1 are driven outputs, bits 0 are tristate)
void gpio_set_output_enable(uint32_t value){
  IOB_GPIO_SET_OUTPUT_ENABLE(value);
}
