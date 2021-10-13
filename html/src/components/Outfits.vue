<template>
  <div class="clothing-menu-container">
  <div class="clothing-menu-character-container">
    <div class="clothing-menu-option-header"><p>Outfits</p></div>
    <div class="clothing-menu-option">
      <div class="clothing-menu-option-buttons">
        <div class="clothing-menu-option-item" v-for="(outfit, index) in outfits" v-bind:key="index">
          <div class="clothing-menu-option-item-header"><p>{{outfit.outfitname.toUpperCase()}}</p></div>
          <div class="clothing-menu-option-item-wrapper">
            <v-btn dark @click="useOutfit(outfit.outfitname)">Use</v-btn>
          </div>
        </div>
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
      outfits: []
    }
  },
  methods: {
    async useOutfit(id) {
      const usingOutfit = this.outfits.filter((f) => f.outfitname === id)
      await fetch(`https://qb-clothing/useOutfit`, {method:'POST', body: JSON.stringify({usingOutfit})})
      this.$root.$emit('close')
    }
  },

  mounted() {
    this.outfits = this.data
  }
}
</script>