import React, { useContext, useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

import { BizbazContext } from '../BizbazContext'
import { TAdvert, TReview, } from "../types";

// MUI
import { useTheme } from '@mui/material/styles'
import Box from '@mui/material/Box';
import Divider from '@mui/material/Divider';
import Typography from '@mui/material/Typography';
import Masonry from '@mui/lab/Masonry';

// Components
import { AdvertCard } from '../components/AdvertCard';
import { ReviewCard } from '../components/ReviewCard';

const myShip = `~${window.ship}`

export const Profile = ({ api }: { api: any }) => {
  const bizbaz = useContext(BizbazContext);
  const { ship } = useParams();
  const theme = useTheme();

  const { adverts, reviews } = bizbaz;
  const [filteredAds, setFilteredAds] = useState([] as Array<TAdvert>);
  const [filteredReviewsByMe, setFilteredReviewsByMe] = useState([] as Array<TReview>);
  const [filteredReviewsOfMe, setFilteredReviewsOfMe] = useState([] as Array<TReview>);

  useEffect(() => {
    setFilteredAds(adverts.filter(a => a.vendor.ship === ship));
  }, [adverts]);


  useEffect(() => {
    setFilteredReviewsByMe(reviews.filter(r => r.reviewer.ship === ship));
    setFilteredReviewsOfMe(reviews.filter(r => r.body.reviewee === ship));

  }, [reviews]);


  return (
    <Box sx={{width: "100%", mt: theme.spacing(10),
      minHeight: '100vh', justifyContent: 'center' 
    }}>
      <Typography variant="h2" sx={{ mx: 2, my: 6 }}>
        {ship == myShip ? "My Profile" : `Profile of ${ship}`}
      </Typography>

      <Typography variant="h4" sx={{ mx: 2, my: 4 }}>
        {ship == myShip ? "My Adverts" : `Adverts by ${ship}`}
      </Typography>
      {filteredAds.length > 0 ?
        <Masonry columns={3} spacing={2}>
          {filteredAds.map((advert: TAdvert, index: number) => {
            return (
              <AdvertCard key={index} advert={advert}/>
            )
          })}
        </Masonry> :
        <Typography sx={{m: 2}}>
          {ship === myShip ? 'You have' : 'This vendor has '} not posted any ads.
        </Typography>
      }

      <Divider />
      
      <Typography variant="h4" sx={{ mx: 2, my: 4 }}>
        {ship == myShip ? "My Reviews" : `Reviews by ${ship}`}
      </Typography>
      {filteredReviewsByMe.length > 0 ?
        <Masonry columns={3} spacing={2}>
          {filteredReviewsByMe!.map((review: TReview, index: number) => {
            return (
              <ReviewCard key={index} review={review} api={api} />
            )
          })}
        </Masonry> :
        <Typography sx={{m: 2}}>
          {ship === myShip ? 'You have' : 'This vendor has '} not reviewed any ads.
        </Typography>
      }

      <Divider />

      <Typography variant="h4" sx={{ mx: 2, my: 4 }}>
        {ship == myShip ? "Reviews of me" : `Reviews of ${ship}`}
      </Typography>
      {filteredReviewsOfMe!.length > 0 ?
        <Masonry columns={3} spacing={2}>
          {filteredReviewsOfMe!.map((review: TReview, index: number) => {
            return (
              <ReviewCard key={index} review={review} api={api} />
            )
          })}
        </Masonry> :
        <Typography gutterBottom sx={{m: 2}}>
          {ship === myShip ? "Your " : "This vendor's "}
          profile has not been reviewed by anyone yet.
        </Typography>
      }

    </Box>
  )
}
