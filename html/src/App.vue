<template>
  <v-app v-if="isVisible">
    <div class="container">
      <div class="change-camera-buttons">
        <div class="change-camera-buttons-wrapper">
          <div class="change-camera-button">
          <v-btn dark elevation="2" @click="rotate('left')"
            ><i class="fas fa-angle-left"></i
          ></v-btn>
        </div>

        <div class="change-camera-button" data-rotation="right">
          <v-btn dark elevation="2" @click="rotate('right')"
            ><i class="fas fa-angle-right"></i
          ></v-btn>
        </div>
        </div>
        <div class="change-camera-footer">
          <p>Camera Rotate</p>
        </div>
      </div>
      <div class="selection-menu-container">
        <div class="selection-menu-wrapper">
          <div v-if="showNavigationButtons === 0">
            <v-tooltip left>
              <template v-slot:activator="{on,attrs}">
                <v-btn v-bind="attrs" v-on="on" v-bind:class="`${navigationSelect === 0 ? 'active' : ''}`"><i class="fas fa-suitcase"></i></v-btn>
              </template>
              <span>Outfits</span>
            </v-tooltip>
          </div>
          <div v-if="showNavigationButtons === 1 || showNavigationButtons === 3">
            <v-tooltip left>
              <template v-slot:activator="{on,attrs}">
                <v-btn v-bind="attrs" v-on="on" v-bind:class="`${navigationSelect === 1 ? 'active' : ''}`" dark elevation="2" @click="setNavigation(1)"><i class="fas fa-hat-cowboy"></i></v-btn>
              </template>
              <span>Skin Customization</span>
            </v-tooltip>
          </div>
          <div v-if="showNavigationButtons === 2 || showNavigationButtons === 3">
            <v-tooltip left>
              <template v-slot:activator="{on,attrs}">
                <v-btn v-bind="attrs" v-on="on" v-bind:class="`${navigationSelect === 2 ? 'active' : ''}`" dark elevation="2" @click="setNavigation(2)"><i class="fas fa-tshirt"></i></v-btn>
              </template>
              <span>Clothes Customization</span>
            </v-tooltip>
          </div>
        </div>
      </div>
        <Outfits v-if="navigationSelect === 0" v-bind:data="outfits"/>
        <Skins v-if="navigationSelect === 1" v-bind:skin="skin" v-bind:isNewPlayer="isNew"/>
        <Clothes v-if="navigationSelect === 2" v-bind:clothes="clothes" v-bind:isNew="isNew"/>
        <div class="clothing-menu-actions">
          <v-btn class="skinButton" v-if="!displayDialog" @click="save">Save</v-btn>
          <v-col cols="auto" v-if="displayDialog">
            <v-dialog
                transition="dialog-top-transition"
                max-width="600"
                v-model="dialog"
            >
              <template v-slot:activator="{ on, attrs }">
                <v-btn class="skinButton" v-bind="attrs" v-on="on">Save</v-btn>
              </template>
              <template >
                <v-card>
                  <v-toolbar color="secondary" dark>Save your outfit</v-toolbar>
                  <v-card-text>
                    <v-text-field v-model="outfitName" label="Enter the outfit name"></v-text-field>
                  </v-card-text>
                  <v-card-actions class="justify-end">
                    <v-btn text @click="save">Save Outfit</v-btn>
                  </v-card-actions>
                </v-card>
              </template>
            </v-dialog>
          </v-col>
          <v-btn dark @click="cancelNUI" class="skinButton">Cancel</v-btn>
        </div>
      </div>
  </v-app>
</template>

<script>

import Skins from "./components/Skins.vue";
import Clothes from "./components/Clothes.vue";
import Outfits from "./components/Outfits.vue";

export default {
  name: 'App',

  components: {
    Skins,
    Clothes,
    Outfits
  },

  data() {
    return {
      isVisible: false,
      publicPath: process.env.BASE_URL,
      cameraSelect: 0,
      navigationSelect: 0,
      showNavigationButtons: 0,
      displayDialog: true,
      dialog: false,
      outfitName: '',
      skin: [],
      clothes: [],
      outfits: [],
      isNew: false,
      activeNUI: ''
    };
  },

  methods: {
    setCamera(id) {
      this.cameraSelect = id
      fetch(`https://qb-clothing/setupCam`, {method: 'POST', body: JSON.stringify({value: id})})
    },
    rotate(type) {
      fetch(`https://qb-clothing/rotateCam`, {
        method: 'POST',
        body: JSON.stringify({type})
      })
    },
    save() {
      if (this.activeNUI == 'setNew') {
        fetch(`https://qb-clothing/save`, {method: 'POST', body: JSON.stringify({newPlayer: true})})
      } else {
        if (this.outfitName === '') return;
        fetch(`https://qb-clothing/saveOutfit`, {method: 'POST', body: JSON.stringify({outfitName: this.outfitName})})
      }
      this.reset()
    },
    showMain(visible) {
      this.isVisible = visible;
    },
    setSkins(data) {
      this.skin = data.skins
      this.navigationSelect = 1
      this.showNavigationButtons = 1
      this.showMain(true)
    },
    setBoth(data) {
      this.skin = data.skins
      this.clothes = data.clothes
      this.showNavigationButtons = 3
      this.navigationSelect = 1
      this.isNew = data.isNew
      this.showMain(true)
      this.activeNUI = 'setBoth'
    },
    setNavigation(id) {
      this.navigationSelect = id
    },
    setClothes(data) {
      this.clothes = data.clothes
      this.showNavigationButtons = 2
      this.navigationSelect = 2
      this.showMain(true)
      this.activeNUI = 'setClothes'
    },
    setOutfits(data) {
      this.outfits = data
      this.showNavigationButtons = 0
      this.navigationSelect = 0
      this.showMain(true)
      this.activeNUI = 'setOutfits'
    },
    setNew(data) {
      this.clothes = data.clothes
      this.skin = data.skins
      this.showNavigationButtons = 3
      this.navigationSelect = 1
      this.showMain(true)
      this.displayDialog = false
      this.isNew = true
      this.activeNUI = 'setNew'
    },
    cancelNUI() {
      if (this.activeNUI === 'setNew') return
      if (this.activeNUI === 'setBoth') return
      if (this.activeNUI === 'setClothes' || this.activeNUI === 'setSkins') {
        fetch(`https://qb-clothing/close`, {method: 'POST', body: JSON.stringify({saveClothes: false, saveSkin: false})})
        this.reset()
      } else if (this.activeNUI === 'setOutfits') {
        fetch(`https://qb-clothing/closeMenu`, {method: 'POST', body: JSON.stringify({})})
        this.reset()
      }
    },
    close() {
      if (this.activeNUI === 'setBoth') {
        this.dialog = !this.dialog
      }
      if (this.displayDialog) return
      if (this.activeNUI === 'setOutfits') {
        fetch(`https://qb-clothing/closeMenu`, {method: 'POST', body: JSON.stringify({})})
      } else { 
        fetch(`https://qb-clothing/close`, {method: 'POST', body: JSON.stringify({saveClothes: false, saveSkin: false})})
      }
      this.reset()
    },
    reset() {
      this.showMain(false)
      this.navigationSelect = 0
      this.showNavigationButtons = 0
      this.displayDialog = true
      this.outfitName = ""
      this.dialog = false
      this.cameraSelect = 0
    }
  },
  destroyed() {
    window.removeEventListener('message', this.listener);
    window.removeEventListener('keydown', this.keydownListener);
  },
  mounted() {
    this.$root.$on('close', () => {
      this.reset()
    })

    this.$root.$on('setCamera', (id) => {
      this.setCamera(id)
    })
    this.listener = window.addEventListener(
        'message',
        event => {
          const element = event.data || event.detail;
          console.log(element, event.data.type)
          if (this[element.type]) {
            this[element.type](element.data);
          }
        },
        false,
    );
    this.keydownListener = window.addEventListener('keydown', async (event) => {
      if (event.key === 'Escape') {
        if(this.displayDialog) return;
        this.showMain(false)
        let type = '';
        if (this.navigationSelect === 1) {
          type = 'skin'
        } else {
          type = 'clothes'
        }
        await fetch(`https://qb-clothing/close`, {method: 'POST', body: JSON.stringify({type})})
      } else if (event.key === 'd') {
        await fetch(`https://qb-clothing/rotateRight`, {method: 'POST', body: JSON.stringify({})})
      } else if (event.key === 'a') {
        await fetch(`https://qb-clothing/rotateLeft`, {method: 'POST', body: JSON.stringify({})})
      }
    })
  }
};
</script>

<style lang="scss">
@import url('https://fonts.googleapis.com/css2?family=Love+Ya+Like+A+Sister&display=swap');
  body {
    overflow-x: hidden;
  }

  ::-webkit-scrollbar {
  width: 0 !important
  }

  .theme--dark.v-application {
    background: transparent !important;
    .v-input,
    .v-input__control,
    .v-input__slot,
    .v-text-field__slot,
    input::-webkit-outer-spin-button,
    .v-input,
    .v-input__control,
    .v-input__slot,
    .v-text-field__slot,
    input::-webkit-inner-spin-button {
      -webkit-appearance: none !important;
      margin: 0;
    }
    .v-text-field input {
      text-align: center;
    }
    ::-webkit-scrollbar-track {
      -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.05);
      background-color: rgba(245, 245, 245, 0.089);
    }

    ::-webkit-scrollbar {
      width: 0.4vh;
      background-color: rgba(245, 245, 245, 0.089);
    }

    ::-webkit-scrollbar-thumb {
      background-color: #dd2e2edc;
    }
    .clothing-menu-actions {
      position: absolute;
      width: 100%;
      display: flex;
      right: 5%;
      bottom: 0%;
      flex-wrap: wrap;
      flex-direction: row;
      justify-content: space-evenly;
      /* align-items: center; */
      align-items: center;
    }
    .skinButton {
      width: 10vw;
      font-family: 'Love Ya Like A Sister', sans-serif !important;
      font-weight: 900;
      font-size: 20px;
      letter-spacing: 0.2em;
    }

    .clothesButton {
      width: 10vw;
      font-family: 'Love Ya Like A Sister', sans-serif !important;
      font-weight: 900;
      font-size: 20px;
      letter-spacing: 0.2em;
    }
    .container {
      width: 100%;
      height: 100%;
      font-family: 'Love Ya Like A Sister', cursive;
      font-weight: 900;
      display: flex;
      justify-content: center;

      .selection-menu-container {
        position: absolute;
        right: 30vw;

        .selection-menu-wrapper {
          width: 5%;
          position: relative;
          flex-direction: column;
          display: flex;
        }

        .selection-menu-wrapper div {
          margin-top: 2vw;
        }
      }

      .change-camera-buttons {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        height: 7vh;
        width: 20vh;
        background-color: rgba(0, 0, 0, 0.3);
        // background: url('./assets/background-black.png');
        // background-repeat: no-repeat;
        // background-position: center;
        // background-size: 100% 100%;


        .change-camera-buttons-wrapper {
          width: 100%;
          display: flex;
          margin-top: 1.5vw;
          justify-content: space-evenly;
          align-items: center;

          .clothing-menu-header-camera-btn {
            height: 60%;
            width: 20%;
            margin-top: 4%;
            float: left;
            color: white;
            text-align: center;
            display: flex;
            justify-content: center;
            align-items: center;
            border-bottom: 2px solid rgba(255, 255, 255, 0);
            transition: all 0.1s linear;
          }
        }

        .change-camera-button {
          font-family: 'Love Ya Like A Sister', cursive;
        }

        .change-camera-button .v-btn i {
          font-size: 30px;
        }

        .change-camera-button > i {
          font-size: 3vh;
          color: white;
          line-height: 5.5vh;
        }

        .change-camera-footer {
          color: red;
          font-weight: 900;
          font-size: 17px;
          filter: drop-shadow(0 0 2px #000);
          letter-spacing: 0.1em;
        }
      }

      .clothing-menu-container {
        position: absolute;
        width: 45vh;
        height: 90%;
        //background: url(./assets/background-black.png);
        //background-repeat: no-repeat;
        overflow: hidden;
        background-color: rgba(0, 0, 0, 0.8);
        //background-size: 101% 100%;
        right: 2vw;

        .clothing-menu-header-cameras {
          width: 100%;
          height: 5%;
          display: flex;
          justify-content: space-evenly;
          align-items: center;
        }

      }
    }

    .active {
      background-color: rgba(255, 0, 0, 0.3) !important;
    }
  }
</style>

