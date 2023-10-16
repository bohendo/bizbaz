import React, { useEffect } from "react";
import { TReview, TIntent } from "../types";

// MUI
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardHeader from '@mui/material/CardHeader';
import Grid from '@mui/material/Grid';
import Rating from '@mui/material/Rating';
import Typography from '@mui/material/Typography';

// Components
import { AdvertLink } from "./AdvertLink"
import { ShipLink } from "./ShipLink"

export const ReviewCard = ({ review }: {
    review: TReview;
}) => {
  const reviewer = review ? review.reviewer.ship : "..."
  const reviewee = review ? review.body.reviewee : "..."
  const advert = review ? review.commit.intent.advert : "..."
  return (
    <Card variant="outlined" sx={{ p: 8, mx: 8, my: 2 }}>
      <CardHeader
        title={
          <Rating
            defaultValue={review.body.score}
            readOnly={true}
            size="large"
          />
        }
        subheader={
          <Typography>
            <ShipLink ship={reviewer}/> reviewed <ShipLink ship={reviewee}/>
          </Typography>
        }
      />

      <CardContent>
        <Typography variant="body1">
          {review.body.why}
        </Typography>
      </CardContent>

      <CardContent sx={{ m: 0, py: 0 }}>
        <Grid container spacing={2}>
          <Grid item xs={6}>
            <Box sx={{ display: 'flex', justifyContent: 'left' }}>
              <Typography variant='body1'>
                <AdvertLink advert={review.commit.intent.advert}/>
              </Typography>
            </Box>
          </Grid>
          <Grid item xs={6}>
            <Box sx={{ display: 'flex', justifyContent: 'right' }}>
              <Typography variant='body1'>
                {new Date(review.body.when * 1000).toLocaleString()}
              </Typography>
            </Box>
          </Grid>
        </Grid>
      </CardContent>

      {/* TODO: add edit button */}

    </Card>
  )
}
