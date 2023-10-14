import React, { useEffect } from "react";
import { Link } from 'react-router-dom';

export const ShipLink = ({ ship }: { ship: string }) => {
  // TODO: add sigil?
  return (
    <Link to={`/profile/${ship}`}>
      {ship}
    </Link> 
  )
};

