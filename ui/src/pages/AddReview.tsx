import React, {useEffect, useState} from "react";

export const AddReview = ({
    api
// TODO: Fix api type
}: {api: any}) => {

const postReview = () => {
    api.poke({
        app: 'bizbaz',
        mark: 'review-action',
        json: { 
            'post-review': { 
            review: {
                reviewee: "~nec",
                reviewer: `~${window.ship}`,
                what: "test review",
                when: 1630471524
            }
            }
        }
        })
    }
}
