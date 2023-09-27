export type ListingValidation = {
    hasError: boolean;
    errorMsgs: {
        descriptionError: string;
        tagsError: string;
    }

}

export type NewListing = {
    description: string;
    tags: Array<string>;
}

export type Listing = {
    description: string;
    tags: Array<string>;
    when: number;
    who: string;
}