import React, { useEffect } from "react";
import { Link } from 'react-router-dom';

export const AdvertLink = ({ advert }: { advert: string }) => {
  return (
    <Link to={`/advert/${advert}`}>
      advert ..{advert.substring(advert.length - 5)}
    </Link> 
  )
};
