<template>
    <div class="clothing-menu-container">
      <div class="clothing-menu-header-cameras">
        <v-btn dark elevation="2" @click="setCamera(1)" v-bind:class="`clothing-menu-header-camera-btn ${cameraSelect === 1 ? 'active' : ''}`">
          <i class="fas fa-horse-head"></i>
        </v-btn>
        <v-btn dark elevation="2" @click="setCamera(2)" v-bind:class="`clothing-menu-header-camera-btn ${cameraSelect === 2 ? 'active' : ''}`">
          <i class="fas fa-tshirt"></i>
        </v-btn>
        <v-btn dark elevation="2" @click="setCamera(3)" v-bind:class="`clothing-menu-header-camera-btn ${cameraSelect === 3 ? 'active' : ''}`">
          <i class="fas fa-socks"></i>
        </v-btn>
      </div>
  <div class="clothing-menu-character-container">
    <div class="clothing-menu-option-header"><p>Clothes Customization</p></div>
    <div class="clothing-menu-option">
      <div class="clothing-menu-option-buttons">
        <div class="clothing-menu-option-item" v-for="(cloth, index) of currentClothes" v-bind:key="index">
          <v-row justify="center">
            <v-expansion-panels inset>
              <v-expansion-panel>
                <v-expansion-panel-header>{{cloth.name.replace("_", " ").toUpperCase()}} | {{cloth.currentValue}} | {{cloth.maxValue}}</v-expansion-panel-header>
                <v-expansion-panel-content>
                  <div class="clothing-menu-option-item-wrapper">
                    <div class="clothing-menu-option-item-arrows">
                      <div><v-btn dark  @click="onClickHandler('dec', index)"><i class="fas fa-arrow-left"></i></v-btn></div>
                      <div><v-text-field  type="number" dark center :value="cloth.currentValue"></v-text-field></div>
                      <div><v-btn dark  @click="onClickHandler('inc', index)"><i class="fas fa-arrow-right"></i></v-btn></div>
                    </div>
                    <div>
                      <v-slider v-model="cloth.currentValue" thumb-color="red" dark @change="onChangeCloth" :min="cloth.minValue" :max="cloth.maxValue"></v-slider>
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
    </div>
</template>

<script>
  export default {
    props: ['clothes', 'isNewPlayer'],
    data() {
      return {
        currentClothes: [],
        cameraSelect: 0,
        isNew: false
      }
    },

    methods: {
      setCamera(id) {
        this.$root.$emit('setCamera', id)
        this.cameraSelect = id
      },
      onChangeCloth() {
        fetch(`https://qbr-clothing/applyClothes`, {method: 'POST', body: JSON.stringify({values: this.clothes})})
      },
      onClickHandler(type, element) {
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
        fetch(`https://qbr-clothing/applyClothes`, {method: 'POST', body: JSON.stringify({values: this.clothes})})
      }
    },

    mounted() {
      this.currentClothes = this.clothes
      this.isNew = this.isNewPlayer
    }
  }
</script>