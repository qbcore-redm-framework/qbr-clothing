<template>
  <div>
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
        <div class="clothing-menu-option-header"><p>Skin Customization</p></div>
        <div class="clothing-menu-option">
            <div class="clothing-menu-option-buttons">
              <div class=""><v-btn dark elevation="2" @click="removeHat"><i class="fas fa-min-square"></i>Remove Hat</v-btn></div>
              <div class="clothing-menu-option-item" v-for="(skin, index) of skins.skinDetails" v-bind:key="index">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>{{skin.name.replace(/_/g, " ").toUpperCase()}} | {{skin.currentValue}} | {{skin.maxValue}}</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div class="clothing-menu-option-item-arrows">
                            <div><v-btn dark @click="onClickHandler('dec', index, skin.name)"><i class="fas fa-arrow-left"></i></v-btn></div>
                            <div><v-text-field  type="number" dark center :value="skin.currentValue"></v-text-field></div>
                            <div><v-btn dark @click="onClickHandler('inc', index, skin.name)"><i class="fas fa-arrow-right"></i></v-btn></div>
                          </div>
                          <div>
                            <v-slider thumb-color="red" v-model="skin.currentValue"  @change="onChangeSkin($event)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item" v-if="skins.overlays.eyebrows !== undefined">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Eyebrows</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.eyebrows" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Wrinkles</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.wrinkles" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Freckles</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.freckles" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Lipsticks</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.lipsticks" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Blush</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.blush" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Moles</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.moles" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Eyeliner</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.eyeliner" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Shadows</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.shadows" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Scars</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.scars" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
                          </div>
                        </div>
                      </v-expansion-panel-content>
                    </v-expansion-panel>
                  </v-expansion-panels>
                </v-row>
              </div>
              <div class="clothing-menu-option-item">
                <v-row justify="center">
                  <v-expansion-panels inset>
                    <v-expansion-panel
                    >
                      <v-expansion-panel-header>Pears</v-expansion-panel-header>
                      <v-expansion-panel-content>
                        <div class="clothing-menu-option-item-wrapper">
                          <div v-for="(skin, index) of skins.overlays.pears" v-bind:key="index">
                            <v-slider :label="skin.name.replace(/_/g, ' ').toUpperCase()" thumb-color="red" v-model="skin.currentValue"  @change="onChangeOverlay($event, index)" dark :min="skin.minValue" :max="skin.maxValue"></v-slider>
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
  </div>
</template>

<script>
    export default {
        props: ['skin', 'isNewPlayer'],
        data() {
            return {
                skins: [],
                cameraSelect: 0,
                isNew: false,
            }
        },

      methods: {
        onChangeOverlay() {
          this.applySkins()
        },

        setCamera(id) {
          this.$root.$emit('setCamera', id)
          this.cameraSelect = id
        },

        onChangeSkin() {
          this.applySkins()
        },

        async removeHat() {
          fetch(`https://qbr-clothing/removeHat`, {method: 'POST', body: JSON.stringify({})})
        },

        onClickHandler(type, element) {
          if (type === 'inc') {
            this.skins.skinDetails[element].currentValue += 1
            if (this.skins.skinDetails[element].currentValue > this.skins.skinDetails[element].maxValue) {
              this.skins.skinDetails[element].currentValue = this.skins.skinDetails[element].maxValue
            }
          } else if (type === 'dec') {
            this.skins.skinDetails[element].currentValue -= 1
            if (this.skins.skinDetails[element].currentValue < this.skins.skinDetails[element].minValue) {
              this.skins.skinDetails[element].currentValue = this.skins.skinDetails[element].minValue
            }
          }
          this.applySkins()
        },

        applySkins() {
          fetch(`https://qbr-clothing/applySkin`, {method : 'POST', body : JSON.stringify({values: this.skins})})
        },

      },
      mounted() {
        // console.log(JSON.stringify(this.skins, null, 2))
        // console.log(this.data)
        this.skins = this.skin
        this.isNew = this.isNewPlayer
      }
    }
</script>

<style lang="scss">
    .clothing-menu-character-container {
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        flex-direction: column;
        align-items: center;

        .clothing-menu-option-header {
            width: 90%;
            height: 5%;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: rgba(255, 50, 40, 0.5);
            //background: url(../assets/background-red.png);
            //background-size: 100% 200%;
            //background-position: center;
            box-shadow: 0 0 2px #000;
        }

        .clothing-menu-option-header p {
            color: white;
            font-size: 20px;
            font-family: 'Love Ya Like A Sister', cursive;
            letter-spacing: 0.2em;
            margin-top: 3%;
            filter: drop-shadow(0 0 2px #000);
        }

        .clothing-menu-option {
            width: 100%;
            height: 80%;
            overflow-y: scroll;
        }

        .clothing-menu-option-buttons {
            width: 100%;
            display: flex;
            flex-wrap: wrap;
            flex-direction: row;
            justify-content: space-evenly;
            align-items: center;

            .clothing-menu-option-item {
                width: 90%;
                margin-left: 2%;
                margin-top: 10%;

                .clothing-menu-option-item-header {
                    width: 100%;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    color: white;
                    font-size: 22px;
                    font-family: 'Love Ya Like A Sister', cursive;
                    letter-spacing: 0.2em;
                }

                .clothing-menu-option-item-wrapper {
                    height: 100%;
                    width: 100%;
                    margin-left: 2%;
                    display: flex;
                    justify-content: space-between;
                    flex-direction: column;
                    margin-top: 2%;

                    .clothing-menu-option-item-arrows {
                        width: 100%;
                        display: flex;
                        justify-content: space-evenly;
                        align-items: center;
                        margin-bottom: 2%;
                    }

                        .clothing-menu-option-item-left {
                        padding: 5% 10%;
                        background-color: rgb(136, 136, 136);
                        color: #e9e9e9;
                        text-align: center;
                        /* line-height: 5vh; */
                        border-radius: 5px 0px 0px 5px;
                        transition: all 0.1s linear;
                    }

                        .clothing-menu-option-item-right {
                        padding: 5% 10%;
                        background-color: rgb(136, 136, 136);
                        color: #e9e9e9;
                        text-align: center;
                        /* line-height: 5vh; */
                        border-radius: 0px 5px 5px 0px;
                        transition: all 0.1s linear;
                        margin-right: 10%;
                    }

                }
            }
        }
    }
</style>