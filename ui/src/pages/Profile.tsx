import React, { useContext } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

import { BizbazContext } from '../BizbazContext'
import { TAdvert, TReview, } from "../types";

// MUI
import { useTheme } from '@mui/material/styles'
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Masonry from '@mui/lab/Masonry';

// Components
import { AdvertCard } from '../components/AdvertCard';
import { ReviewCard } from '../components/ReviewCard';

const myShip = `~${window.ship}`

export const Profile = () => {
  const bizbaz = useContext(BizbazContext);
  const { ship } = useParams();
  const theme = useTheme();

  const { adverts, votes, intents, commits, reviews } = bizbaz;

  return (
    <Box sx={{width: "100%", mt: theme.spacing(10)}}>
      <Typography variant="h2" sx={{ mx: 2, my: 6 }}>
        {ship == myShip ? "My Profile" : `Profile of ${ship}`}
      </Typography>

      <Typography variant="h4" sx={{ mx: 2, my: 4 }}>
        {ship == myShip ? "My Adverts" : `Adverts by ${ship}`}
      </Typography>
      <Masonry columns={3} spacing={2}>
        {adverts.filter(a => a.vendor.ship === ship).map((advert: TAdvert, index: number) => {
          return (
            <AdvertCard key={index} advert={advert}/>
          )
        })}
      </Masonry>

      <Typography variant="h4" sx={{ mx: 2, my: 4 }}>
        {ship == myShip ? "My Reviews" : `Reviews by ${ship}`}
      </Typography>
      <Masonry columns={3} spacing={2}>
        {reviews.filter(r => r.reviewer.ship === ship).map((review: TReview, index: number) => {
          return (
            <ReviewCard key={index} review={review}/>
          )
        })}
      </Masonry>

      <Typography variant="h4" sx={{ mx: 2, my: 4 }}>
        {ship == myShip ? "Reviews of me" : `Reviews of ${ship}`}
      </Typography>
      <Masonry columns={3} spacing={2}>
        {reviews.filter(r => r.body.reviewee === ship).map((review: TReview, index: number) => {
          return (
            <ReviewCard key={index} review={review}/>
          )
        })}
      </Masonry>

    </Box>
  )
}
