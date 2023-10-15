import React, { useEffect } from "react";
import { TReview, TIntent } from "../types";

// Components
import { AdvertLink } from "./AdvertLink"
import { ShipLink } from "./ShipLink"

// MUI
import Box from '@mui/material/Box';
import Card from '@mui/material/Card';
import CardHeader from '@mui/material/CardHeader';
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import Rating from '@mui/material/Rating';

export const ReviewCard = ({ review }: {
    review: TReview;
}) => {
  const reviewer = review ? review.reviewer.ship : "..."
  const reviewee = review ? review.body.reviewee : "..."
  const advert = review ? review.commit.intent.advert : "..."
  return (
    <Card variant="outlined" sx={{ p: 2 }}>

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
            <ShipLink ship={reviewer}/> reviewed <ShipLink ship={reviewee}/> on <AdvertLink advert={advert}/>
          </Typography>
        }
      />

      <CardContent>
        <Typography variant="body1">
          {review.body.why}
        </Typography>
      </CardContent>

      {/* TODO: add edit button */}

    </Card>
  )
}
