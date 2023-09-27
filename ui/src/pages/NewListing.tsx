import React, {useEffect, useState} from "react";

// MUI Components
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';
import Button from "@mui/material/Button";

import { TNewListing, TListingValidation  } from "../types";

export const NewListing = ({
    open,
    handleCloseDialog,
    api
}: {
    open: boolean;
    handleCloseDialog: () => void;
    // TODO: Fix api type
    api: any
}) => {
    const [validation, setValidation] = useState({
        hasError: false,
        errorMsgs: {
            titleError: "",
            descriptionError: "",
            tagsError: ""
        }
    } as TListingValidation)
    const [newListing, setNewListing] = useState({
        title: "",
        description: "",
        tags: []
    } as TNewListing);

    const validate = (listing: TNewListing) => {
       const titleError = !listing.title ? "Listing must have a title" : "";
       const descriptionError = !listing.description ? "Listing description is required" : "";
       let tagsError = listing.tags.reduce((tagError, tag) =>
            /^[a-z][a-z0-9-]*$/.test(tag) ? tagError : tagError + ` '${tag}'`,
            "");
    
        if (tagsError) 
            tagsError = "Tags must start with an alphabet and only contain alphanumeric and '-' symbols. \
                         Following are invalid tags: "
                        + tagsError;
       const hasError = !!(descriptionError || tagsError);
       setValidation({ hasError, errorMsgs: {titleError, descriptionError, tagsError}});
    }
    const syncNewListing = (listing: TNewListing) => {
       validate(listing);
       setNewListing(listing);
    }

    const postListing = () => {
        validate(newListing);
        if (validation.hasError) return;
        api.poke({
          app: 'bizbaz',
          mark: 'listing-action',
          json: { 
            'create': { 
              listing: {
                who: `~${window.ship}`,
                tags: newListing.tags,
                description: newListing.description,
                when: Math.floor((new Date()).getTime() / 1000)
              }
            }
          }
        })
        handleCloseDialog()
    }

    return (
        <Dialog open={open} onClose={handleCloseDialog}>
            <DialogContent>
               <DialogContentText>
                  Create New Listing
               </DialogContentText>
               <TextField
                    autoFocus
                    error={!!validation.errorMsgs.titleError}
                    margin="dense"
                    id="title"
                    label="Title"
                    type="text"
                    fullWidth
                    helperText={validation.errorMsgs.titleError}
                    variant="standard"
                    onChange={(event) => {
                        syncNewListing({...newListing, [event.target.id]: event.target.value})}
                    }
               />
               <TextField
                    error={!!validation.errorMsgs.descriptionError}
                    margin="dense"
                    id="description"
                    label="Description"
                    type="text"
                    fullWidth
                    helperText={validation.errorMsgs.descriptionError}
                    variant="standard"
                    onChange={(event) => {
                        syncNewListing({...newListing, [event.target.id]: event.target.value})}
                    }
                />
                <TextField
                    error={!!validation.errorMsgs.tagsError}
                    margin="dense"
                    id="tags"
                    label="Tags"
                    type="text"
                    fullWidth
                    helperText={validation.errorMsgs.tagsError}
                    variant="standard"
                    onChange={(event) => {
                        syncNewListing({...newListing, [event.target.id]: event.target.value.toLowerCase().trim().split(" ")})}
                    }
                />

            </DialogContent>
            <DialogActions>
                <Button variant="contained" onClick={postListing}>
                    Submit
                </Button>
            </DialogActions>
        </Dialog>
    )
}