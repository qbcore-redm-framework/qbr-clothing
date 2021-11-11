<template>
  <div class="clothing-menu-character-container">
    <div class="clothing-menu-option-header"><p>Clothes Customization</p></div>
    <div class="clothing-menu-option">
      <div class="clothing-menu-option-buttons">
        <div class="clothing-menu-option-item" v-for="(cloth, index) of clothes" v-bind:key="index">
          <v-row justify="center">
            <v-expansion-panels inset>
              <v-expansion-panel>
                <v-expansion-panel-header>{{cloth['name'].replace("_", " ").toUpperCase()}} | {{cloth.currentValue}} | {{cloth.maxValue}}</v-expansion-panel-header>
                <v-expansion-panel-content>
                  <div class="clothing-menu-option-item-wrapper">
                    <div class="clothing-menu-option-item-arrows">
                      <div><v-btn dark  @click="onClickHandler('dec', index)"><i class="fas fa-arrow-left"></i></v-btn></div>
                      <div><v-text-field  type="number" dark center :value="cloth.currentValue"></v-text-field></div>
                      <div><v-btn dark  @click="onClickHandler('inc', index)"><i class="fas fa-arrow-right"></i></v-btn></div>
                    </div>
                    <div>
                      <v-slider v-model="cloth.currentValue" thumb-color="red" dark @change="onChangeCloth($event, index)" :min="cloth.minValue" :max="cloth.maxValue"></v-slider>
                    </div>
                  </div>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </v-expansion-panels>
          </v-row>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    props: ['data'],
    data() {
      return {
        clothes: []
      }
    },

    methods: {
      async onChangeCloth(event, element) {
        await fetch(`https://qbr-clothing/applyClothes`, {method: 'POST', body: JSON.stringify({category: element, value: this.clothes[element].currentValue})})
      },
      async onClickHandler(type, element) {
        if (type === 'inc') {
          this.clothes[element].currentValue += 1
          if (this.clothes[element].currentValue > this.clothes[element].maxValue) {
            this.clothes[element].currentValue = this.clothes[element].maxValue
          }
        } else if (type === 'dec') {
          this.clothes[element].currentValue -= 1
          if (this.clothes[element].currentValue < 0) {
            this.clothes[element].currentValue = this.clothes[element].maxValue
          }
        }
        await fetch(`https://qbr-clothing/applyClothes`, {method: 'POST', body: JSON.stringify({values: this.clothes})})
      }
    },

    mounted() {
      this.clothes = this.data
    }
  }
</script>
