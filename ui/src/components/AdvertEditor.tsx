import React, {useEffect, useState} from "react";

// MUI Components
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import Button from "@mui/material/Button";

import { Advert, AdvertReq, AdvertValidation  } from "../types";

const defaultReq: AdvertReq = {
  title: "Advert Title",
  cover: "link to cover image",
  description: "Description of the stuff I'm selling",
  tags: ["example"],
};

export const AdvertEditor = ({
    oldAdvert,
    open,
    handleCloseDialog,
    api
}: {
    oldAdvert?: Advert;
    open: boolean;
    handleCloseDialog: () => void;
    // TODO: Fix api type
    api: any
}) => {
    const [validation, setValidation] = useState({
        hasError: false,
        errorMsgs: {
            titleError: "",
            coverError: "",
            descriptionError: "",
            tagsError: ""
        }
    } as AdvertValidation)
    const [advertReq, setAdvertReq] = useState({
        title: oldAdvert?.body?.title || defaultReq.title,
        cover: oldAdvert?.body?.cover || defaultReq.cover,
        description: oldAdvert?.body?.description || defaultReq.description,
        tags: oldAdvert?.body?.tags || defaultReq.tags,
    } as AdvertReq);

    useEffect(() => {
      if (oldAdvert) {
        console.log(`Updating old advert w hash: ${oldAdvert.hash}`)
        setAdvertReq({
          title: oldAdvert.body.title,
          cover: oldAdvert.body.cover,
          description: oldAdvert.body.description,
          tags: oldAdvert.body.tags,
        });
      }
    }, [oldAdvert]);

    const validate = (req: AdvertReq) => {
      const titleError = !req.title ? "Advert must have a title" : "";
      const coverError = !req.cover ? "Advert cover must be a url" : "";
      const descriptionError = !req.description ? "Advert description is required" : "";
      let tagsError = req.tags.reduce((tagError, tag) =>
        /^[a-z][a-z0-9-]*$/.test(tag) ? tagError : tagError + ` '${tag}'`,
        "",
      );
   
       if (tagsError) {
         tagsError = "Tags must start with an alphabet and only contain alphanumeric and '-' symbols. \
                     Following are invalid tags: "
                     + tagsError;
       }
      const hasError = !!(descriptionError || tagsError);
      setValidation({ hasError, errorMsgs: {coverError, titleError, descriptionError, tagsError}});
    }

    const syncNewAdvert = (req: AdvertReq) => {
      validate(req);
      setAdvertReq(req);
    }

    const postAdvert = () => {
      validate(advertReq);
      if (validation.hasError) return;

      if (!!oldAdvert) {
        const req = {
          update: {
            hash: oldAdvert.hash,
            ...advertReq,
          }
        }
        console.log("advert update req", req);
        api.poke({
          app: 'bizbaz',
          mark: 'advert-action',
          json: req,
        })
      } else {
        const req = {
          create: advertReq
        }
        console.log("advert create req", req);
          api.poke({
            app: 'bizbaz',
            mark: 'advert-action',
            json: req,
        })
      }
      handleCloseDialog()
      setAdvertReq(defaultReq)
    }

    return (
        <Dialog open={open} onClose={handleCloseDialog}>
          <DialogContent>
            <DialogContentText>
              {!!oldAdvert ? 
                <>Edit Advert {oldAdvert.hash}</>
                : <> Create New Advert </>
              }
            </DialogContentText>
            <TextField
              autoFocus
              defaultValue={advertReq.title}
              error={!!validation.errorMsgs.titleError}
              margin="dense"
              id="title"
              label="Title"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.titleError}
              variant="standard"
              onChange={(event) => {
                syncNewAdvert({ ...advertReq, [event.target.id]: event.target.value })
              }}
            />
            <TextField
              error={!!validation.errorMsgs.coverError}
              defaultValue={advertReq.cover}
              margin="dense"
              id="cover"
              label="Cover"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.coverError}
              variant="standard"
              onChange={(event) => {
                syncNewAdvert({ ...advertReq, [event.target.id]: event.target.value })
              }}
            />
            <TextField
              error={!!validation.errorMsgs.tagsError}
              defaultValue={advertReq.tags}
              margin="dense"
              id="tags"
              label="Tags"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.tagsError}
              variant="standard"
              onChange={(event) => {
                syncNewAdvert({ ...advertReq, [event.target.id]: event.target.value })
              }}
            />
            <TextField
              error={!!validation.errorMsgs.descriptionError}
              defaultValue={advertReq.description}
              margin="dense"
              id="description"
              multiline={true}
              label="Description"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.descriptionError}
              variant="standard"
              onChange={(event) => {
                syncNewAdvert({ ...advertReq, [event.target.id]: event.target.value })
              }}
            />

          </DialogContent>
          <DialogActions>
            <Button variant="contained" onClick={postAdvert}>
              Submit
            </Button>
          </DialogActions>
        </Dialog>
    )
}
