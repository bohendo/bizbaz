export type TAdvertValidation = {
    hasError: boolean;
    errorMsgs: {
        coverError: string;
        descriptionError: string;
        tagsError: string;
        titleError: string;
    }
}

export type TAdvertBody = {
    cover: string;
    description: string;
    tags: Array<string>;
    title: string;
    when: number;
}

export type TNewAdvert = {
    hash?: string;
    body: TAdvertBody;
}

export type TAdvert = {
    hash: string;
    body: TAdvertBody;
    vendor: {
        life: string;
        ship: string;
        sig: string;
    }
}
