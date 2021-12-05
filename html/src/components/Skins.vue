<template>
  <div class="clothing-menu-character-container">
    <div class="clothing-menu-option-header"><p>Skin Customization</p></div>
    <div class="clothing-menu-option">
      <div class="clothing-menu-option-buttons">
        <div class="clothing-menu-option-item" v-for="(skin, index) of skins" v-bind:key="index">
          <v-row justify="center">
            <v-expansion-panels inset>
              <v-expansion-panel>
                <v-expansion-panel-header>{{skin['name'].replace("_", " ").toUpperCase()}} | {{skin.currentValue}} | {{skin.maxValue}}</v-expansion-panel-header>
                <v-expansion-panel-content>
                  <div class="clothing-menu-option-item-wrapper">
                    <div class="clothing-menu-option-item-arrows">
                      <div><v-btn dark @click="onClickHandler('dec', index)"><i class="fas fa-arrow-left"></i></v-btn></div>
                      <div><v-text-field  type="number" dark center :value="skin.currentValue"></v-text-field></div>
                      <div><v-btn dark @click="onClickHandler('inc', index)"><i class="fas fa-arrow-right"></i></v-btn></div>
                    </div>
                    <div>
                      <v-slider thumb-color="red" v-model="skin.currentValue"  @change="onChangeSkin($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                    </div>
                  </div>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </v-expansion-panels>
          </v-row>
<!--              <div class="clothing-menu-option-item" v-for="(skin, index) of skins['features']" v-bind:key="index">-->
<!--                  <v-row justify="center">-->
<!--                      <v-expansion-panels inset>-->
<!--                      <v-expansion-panel-->
<!--                      >-->
<!--                          <v-expansion-panel-header>{{index.replace("_", " ").toUpperCase()}} | {{skin.currentValue}} | {{skin.maxValue}}</v-expansion-panel-header>-->
<!--                          <v-expansion-panel-content>-->
<!--                              <div class="clothing-menu-option-item-wrapper">-->
<!--                                  <div class="clothing-menu-option-item-arrows">-->
<!--                                      <div><v-btn dark @click="onClickHandlerFeatures('dec', index)"><i class="fas fa-arrow-left"></i></v-btn></div>-->
<!--                                      <div><v-text-field  type="number" dark center :value="skin.currentValue"></v-text-field></div>-->
<!--                                      <div><v-btn dark @click="onClickHandlerFeatures('inc', index)"><i class="fas fa-arrow-right"></i></v-btn></div>-->
<!--                                  </div>-->
<!--                                  <div>-->
<!--                                      <v-slider thumb-color="red" v-model="skin.currentValue" @change="onChangeFeatures($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>-->
<!--                                  </div>-->
<!--                              </div>-->
<!--                          </v-expansion-panel-content>-->
<!--                      </v-expansion-panel>-->
<!--                      </v-expansion-panels>-->
<!--                  </v-row>-->
<!--              </div>-->
<!--              <div class="clothing-menu-option-item" v-for="(skin, index) of skins['overlays']" v-bind:key="index">-->
<!--                <v-row justify="center">-->
<!--                  <v-expansion-panels inset>-->
<!--                    <v-expansion-panel-->
<!--                    >-->
<!--                      <v-expansion-panel-header>{{index.replace("_", " ").toUpperCase()}}</v-expansion-panel-header>-->
<!--                      <v-expansion-panel-content>-->
<!--                        <div class="clothing-menu-option-item-wrapper">-->
<!--                          <div v-for="(s, i) of skin" v-bind:key="i">-->
<!--                            <v-slider v-model="s.currentValue" thumb-color="red" @change="onChangeOverlay($event, index)" :label="i.replace('_', ' ').toUpperCase()" dark :min="s.minValue" :max="s.maxValue"></v-slider>-->
<!--                          </div>-->
<!--                        </div>-->
<!--                      </v-expansion-panel-content>-->
<!--                    </v-expansion-panel>-->
<!--                  </v-expansion-panels>-->
<!--                </v-row>-->
<!--              </div>-->
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
                skins: []
            }
        },

      methods: {
        async onChangeOverlay(event, element) {
          fetch(`https://qbr-clothing/applyOverlay`, {
            method: 'POST',
            body: JSON.stringify({
              category: element,
              value: this.skins["overlays"][element]
            })
          })
        },

        async onChangeSkin(event, element) {
          fetch(`https://qbr-clothing/applySkin`, {method: 'POST', body: JSON.stringify({element, value: this.skins[element].currentValue})})
        },

        async onChangeFeatures(event, element) {
          fetch(`https://qbr-clothing/applyFeatures`, {
            method: 'POST',
            body: JSON.stringify({
              category: element,
              value: this.skins["features"][element].currentValue
            })
          })
        },

        async removeHat() {
          fetch(`https://qbr-clothing/removeHat`, {method: 'POST', body: JSON.stringify({})})
        },

        async onClickHandlerFeatures(type, element) {
          if (type === 'inc') {
            this.skins['features'][element].currentValue += 1
            if (this.skins['features'][element].currentValue > this.skins['features'][element].maxValue) {
              this.skins['features'][element].currentValue = this.skins['features'][element].maxValue
            }
          } else if (type === 'dec') {
            this.skins['features'][element].currentValue -= 1
            if (this.skins['features'][element].currentValue < 0) {
              this.skins['features'][element].currentValue = 0
            }
          }
          fetch(`https://qbr-clothing/applyFeatures`, {method : 'POST', body : JSON.stringify({category: element, value: this.skins['features'][element].currentValue})})
        },
        async onClickHandler(type, element) {
          if (type === 'inc') {
            this.skins[element].currentValue += 1
            if (this.skins[element].currentValue > this.skins[element].maxValue) {
              this.skins[element].currentValue = this.skins[element].maxValue
            }
          } else if (type === 'dec') {
            this.skins[element].currentValue -= 1
            if (this.skins[element].currentValue < this.skins[element].minValue) {
              this.skins[element].currentValue = this.skins[element].minValue
            }
          }
          this.applySkins()
        },

        applySkins() {
          fetch(`https://qbr-clothing/applySkin`, {method : 'POST', body : JSON.stringify({values: this.skins})})
        },

      },
      mounted() {
        this.skins = this.data
      }
    }
</script>

<style>
  .clothing-menu-character-container {
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    flex-direction: column;
    align-items: center;
  }
  .clothing-menu-character-container .clothing-menu-option-header {
    width: 90%;
    height: 5%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(255, 50, 40, 0.5);
    box-shadow: 0 0 2px #000;
  }
  .clothing-menu-character-container .clothing-menu-option-header p {
    color: white;
    font-size: 20px;
    font-family: 'Love Ya Like A Sister', cursive;
    letter-spacing: 0.2em;
    margin-top: 3%;
    filter: drop-shadow(0 0 2px #000);
  }
  .clothing-menu-character-container .clothing-menu-option {
    width: 100%;
    height: 80%;
    overflow-y: scroll;
  }
  .clothing-menu-character-container .clothing-menu-option-buttons {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
    flex-direction: row;
    justify-content: space-evenly;
    align-items: center;
  }
  .clothing-menu-character-container .clothing-menu-option-buttons .clothing-menu-option-item {
    width: 90%;
    margin-left: 2%;
    margin-top: 10%;
  }
  .clothing-menu-character-container .clothing-menu-option-buttons .clothing-menu-option-item .clothing-menu-option-item-header {
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    color: white;
    font-size: 22px;
    font-family: 'Love Ya Like A Sister', cursive;
    letter-spacing: 0.2em;
  }
  .clothing-menu-character-container .clothing-menu-option-buttons .clothing-menu-option-item .clothing-menu-option-item-wrapper {
    height: 100%;
    width: 100%;
    margin-left: 2%;
    display: flex;
    justify-content: space-between;
    flex-direction: column;
    margin-top: 2%;
  }
  .clothing-menu-character-container .clothing-menu-option-buttons .clothing-menu-option-item .clothing-menu-option-item-wrapper .clothing-menu-option-item-arrows {
    width: 100%;
    display: flex;
    justify-content: space-evenly;
    align-items: center;
    margin-bottom: 2%;
  }
  .clothing-menu-character-container .clothing-menu-option-buttons .clothing-menu-option-item .clothing-menu-option-item-wrapper .clothing-menu-option-item-left {
    padding: 5% 10%;
    background-color: #888;
    color: #e9e9e9;
    text-align: center;
    /* line-height: 5vh;
    */
    border-radius: 5px 0px 0px 5px;
    transition: all 0.1s linear;
  }
  .clothing-menu-character-container .clothing-menu-option-buttons .clothing-menu-option-item .clothing-menu-option-item-wrapper .clothing-menu-option-item-right {
    padding: 5% 10%;
    background-color: #888;
    color: #e9e9e9;
    text-align: center;
    /* line-height: 5vh;
    */
    border-radius: 0px 5px 5px 0px;
    transition: all 0.1s linear;
    margin-right: 10%;
  }
</style>
