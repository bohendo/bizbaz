import React, {useEffect, useState} from "react";

// MUI Components
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import Button from "@mui/material/Button";

import { TNewAdvert, TAdvertValidation  } from "../types";

export const AdvertEditor = ({
    editAdvert,
    edit,
    open,
    handleCloseDialog,
    api
}: {
    editAdvert?: TNewAdvert;
    edit?: boolean;
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
    } as TAdvertValidation)
    const [newAdvert, setNewAdvert] = useState(editAdvert || {
        body: {
            title: "Advert Title",
            cover: "link to cover image",
            description: "Description of the stuff I'm selling",
            tags: ["example"],
        }
    } as TNewAdvert);

    useEffect(() => {
        if (editAdvert)
            setNewAdvert(editAdvert);
    }, [editAdvert]);

    const validate = (advert: TNewAdvert) => {
       const titleError = !advert.body.title ? "Advert must have a title" : "";
       const coverError = !advert.body.cover ? "Advert cover must be a url" : "";
       const descriptionError = !advert.body.description ? "Advert description is required" : "";
       let tagsError = advert.body.tags.reduce((tagError, tag) =>
            /^[a-z][a-z0-9-]*$/.test(tag) ? tagError : tagError + ` '${tag}'`,
            "");
    
        if (tagsError) 
            tagsError = "Tags must start with an alphabet and only contain alphanumeric and '-' symbols. \
                         Following are invalid tags: "
                        + tagsError;
       const hasError = !!(descriptionError || tagsError);
       setValidation({ hasError, errorMsgs: {coverError, titleError, descriptionError, tagsError}});
    }
    const syncNewAdvert = (advert: TNewAdvert) => {
        validate(advert);
        setNewAdvert(advert);
    }

    const postAdvert = () => {
        validate(newAdvert);
        if (validation.hasError) return;
        const body = {
          ...newAdvert.body,
        };

        if (edit) {
          const req = {
            'update': {
              hash: newAdvert.hash,
              ...body,
            }
          }
          console.log(req);
          api.poke({
            app: 'bizbaz',
            mark: 'advert-action',
            json: req,
          })
        } else {
            const req = {
                'create': body
            }
            api.poke({
              app: 'bizbaz',
              mark: 'advert-action',
              json: req,
          })
        }
        handleCloseDialog()
    }

    return (
        <Dialog open={open} onClose={handleCloseDialog}>
          <DialogContent>
            <DialogContentText>
              {edit ? 
                <>Edit Advert {newAdvert.hash}</>
                : <> Create New Advert </>
              }
            </DialogContentText>
            <TextField
              autoFocus
              defaultValue={newAdvert.body.title}
              error={!!validation.errorMsgs.titleError}
              margin="dense"
              id="title"
              label="Title"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.titleError}
              variant="standard"
              onChange={(event) => {
                syncNewAdvert({ hash: newAdvert.hash, body: {...newAdvert.body, [event.target.id]: event.target.value} })}
              }
            />
            <TextField
              error={!!validation.errorMsgs.coverError}
              defaultValue={newAdvert.body.cover}
              margin="dense"
              id="cover"
              label="Cover"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.coverError}
              variant="standard"
              onChange={(event) => {
                  syncNewAdvert({ hash: newAdvert.hash, body: {...newAdvert.body, [event.target.id]: event.target.value} })}
              }
            />
            <TextField
              error={!!validation.errorMsgs.tagsError}
              defaultValue={newAdvert.body.tags}
              margin="dense"
              id="tags"
              label="Tags"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.tagsError}
              variant="standard"
              onChange={(event) => {
                  syncNewAdvert({ hash: newAdvert.hash, body: { ...newAdvert.body, [event.target.id]: event.target.value.toLowerCase().trim().split(" ") }})}
              }
            />
            <TextField
              error={!!validation.errorMsgs.descriptionError}
              defaultValue={newAdvert.body.description}
              margin="dense"
              id="description"
              multiline={true}
              label="Description"
              type="text"
              fullWidth
              helperText={validation.errorMsgs.descriptionError}
              variant="standard"
              onChange={(event) => {
                  syncNewAdvert({ hash: newAdvert.hash, body: {...newAdvert.body, [event.target.id]: event.target.value} })}
              }
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
