import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';

// MUI
import { useTheme } from "@mui/material/styles"
import Typography from '@mui/material/Typography';

const myShip = `~${window.ship}`

export const Profile = ({ api }: { api: any }) => {
  const { ship } = useParams();
  const theme = useTheme();
  return (
    <Typography variant="h2" sx={{ mx: 2, my: 6 }}>
      {ship == myShip ? "My Profile" : `Profile of ${ship}`}
    </Typography>

  )
}
