export type ListingValidation = {
    hasError: boolean;
    errorMsgs: {
        descriptionError: string;
        tagsError: string;
    }

}

export type Listing = {
    description: string;
    tags: Array<string>;
}