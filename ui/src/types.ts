export type TAdvertValidation = {
    hasError: boolean;
    errorMsgs: {
        titleError: string;
        descriptionError: string;
        tagsError: string;
    }
}

export type TNewAdvert = {
    title: string;
    description: string;
    tags: Array<string>;
}

export type TAdvert = {
    title: string;
    description: string;
    tags: Array<string>;
    when: number;
    who: string;
}
