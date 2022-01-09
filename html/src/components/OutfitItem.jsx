import React, {useEffect, useState} from 'react'

let outfits = []

const useOutfit = async (e) => {
  const usingOutfit = outfits.filter((f) => f.outfitname === e)
  await fetch('https://qbr-clothing/useOutfit', {method: 'POST', body: JSON.stringify({
    usingOutfit
  })})
}

export default function OutfitItem({data}) {

  outfits = data

  return (
    <div className='clothingMenu_option'>
      <p>{outfits['outfitname'].toUpperCase()}</p>
      <div className="clothingItem">
        <button className='button button-solid' onClick={() => useOutfit(outfits.outfitname)}>
          Use
        </button>
      </div>
    </div>
  )
}